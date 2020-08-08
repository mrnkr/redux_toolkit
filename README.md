# redux_toolkit

[![pub package](https://img.shields.io/pub/v/redux_toolkit.svg)](https://pub.dartlang.org/packages/redux_toolkit)
[![Build Status](https://travis-ci.com/mrnkr/redux_toolkit.svg?branch=master)](https://travis-ci.com/mrnkr/redux_toolkit)
[![codecov](https://codecov.io/gh/mrnkr/redux_toolkit/branch/master/graph/badge.svg)](https://codecov.io/gh/mrnkr/redux_toolkit)

Dart port of the official, opinionated, batteries-included toolset for efficient Redux development. Do check out the original [`redux-toolkit`](https://redux-toolkit.js.org/) to see what this lib is inspired on.

## Store setup

A friendly abstraction over the standard way of instantiating the `Store` class. It aims to provide good defaults to provide a smoother experience for us developers.

The defaults are:

- [`redux-thunk`](https://github.com/brianegan/redux_thunk) as the standard way to handle async operations.
- Readily available [`redux_dev_tools`](https://github.com/brianegan/redux_dev_tools) and [`redux_remote_devtools`](https://github.com/MichaelMarner/dart-redux-remote-devtools)

```dart
final store = await configureStore<AppState>((builder) {
  builder.withReducer(reducer);
  builder.withPreloadedState(AppState.initialState());

  if (Config.reduxDevtoolsEnabled) {
    builder.usingDevtools(Config.reduxDevtoolsUrl);
  }
});
```

### API Reference

```dart
Store<State> createStore<State>(StoreBuilderCallback<State>);
typedef StoreBuilderCallback<State> = Function(StoreBuilder<State> builder);

abstract class StoreBuilder<State> {
  StoreBuilder<State> withPreloadedState(State preloadedState);
  StoreBuilder<State> withReducer(Reducer<State> reducer);
  StoreBuilder<State> withMiddleware(Middleware<State> middleware);
  StoreBuilder<State> usingDevtools(String devToolsIpAddr);
}
```

### Quick walkthrough to get `redux_remote_devtools` to work

1. Make sure you have the `remotedev-server` command available in your computer. If you have it, skip until step 2, otherwise, read-on. You have the option of installing it as a dockerized container or as an npm package, I'll show you how to do both:

```bash
# First: the npm installation
npm i -g remotedev-server
# or
yarn global add remotedev-server

# Then launch it
remotedev --port 8000

# Second: the docker way
# The following command will pull the image if you don't have it
# and will leave the server running, no further setup required
docker run -p 8000:8000 jhen0409/remotedev-server
```

2. Use the `usingDevtools` method in your `StoreBuilder` to pass the IP address and port in which you're running your server.

```dart
// To use any IP address within your LAN
builder.usingDevTools('192.168.1.2:5000');

// Or if you want to use loopback
builder.usingDevTools('127.0.0.1:5000');

// Important: THIS WON'T WORK
builder.usingDevTools('localhost:5000'); // ASSERTION ERROR - REQUIRES AN IP ADDRESS STRING
```

3. Make sure everything you want to see in your devtools is json serializable, this means, all your model classes and your state itself. If you want to see your actions properly with all their payloads and stuff they should be json serializable too. The recommended way to achieve this is via the `json_serializable` package, you can check out the example project for that. Basically, all you do is this:

```dart
// todo.dart

import 'package:json_annotation/json_annotation.dart';

// specify the name of the file where the generated code will be
part 'todo.g.dart';

// annotate your class with @JsonSerializable() from json_annotation
@JsonSerializable()
class Todo {
  final int id;
  final String title;
  final bool completed;

  const Todo({
    this.id,
    this.title,
    this.completed,
  });

  // Use the generated code in the factory and in the toJson methods
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
```

```bash
flutter pub run build_runner build # or replace build for watch if you want the generated code to be automatically updated as you write more code :)
```

4. Run your app and see your redux store in real time. You'll also have time travel debugging available for you.

If I missed anything be sure to check out the official docs for [`redux_remote_devtools`](https://github.com/MichaelMarner/dart-redux-remote-devtools) and let me know or make a PR with the correction.

## Reducers and Actions

### `createReducer`

Here is your alternative to writing reducers like the next one:

```dart
State reducer(State s, dynamic a) {
  if (a is Action1) {
    return sPrime;
  }

  if (a is Action2) {
    return sSecond;
  }

  // Tons of if statements like the ones before

  return s;
}
```

The previous reducer would have to be written like this:

```dart
final reducer = createReducer<AppState>(
  AppState.initialState,
  (builder) => builder
    .addCase<Action1>((state, action) => sPrime)
    .addCase<Action2>((state, action) => sSecond),
);
```

If you need to run some code everytime an action is dispatched that is an instance of `MyGenericAction<T>` regardless of what `T` is you'll have to use `addMatcher`.

```dart
final reducer = createReducer<AppState>(
  AppState.initialState,
  (builder) => builder
    .addMatcher(
      (action) => action.runtimeType.toString().startsWith('MyGenericAction'),
      (state, action) => sPrime
    ),
);
```

Lastly, if you need to change what your reducer does when it receives an action you didn't add a case or matcher for you can just add a default case using `addDefaultCase`.

```dart
final reducer = createReducer<AppState>(
  AppState.initialState,
  (builder) => builder
    .addDefaultCase((state) => sPrime),
);
```

#### API Reference

```dart
typedef ActionMatcher<Action> = bool Function(Action action);
typedef CaseReducer<State, Action> = State Function(State state, Action action);
typedef DefaultCaseReducer<State> = State Function(State state);
typedef BuilderCallback<State> = Function(ActionReducerMapBuilder<State> builder);

abstract class ActionReducerMapBuilder<State> {
  ActionReducerMapBuilder<State> addCase<Action>(
      CaseReducer<State, Action> reducer);
  ActionReducerMapBuilder<State> addMatcher<Action>(
      ActionMatcher<Action> actionMatcher, CaseReducer<State, Action> reducer);
  ActionReducerMapBuilder<State> addDefaultCase(
      DefaultCaseReducer<State> reducer);
}

Reducer<State> createReducer<State>(State initialState, BuilderCallback<State> builderCallback);
```

### `PayloadAction` abstract class

Since in flutter we use a different class for each action and that's how we differentiate them there is no `createAction` function like there is in the original `redux-toolkit` for `js` but there is a `PayloadAction` interface for you to implement so that all your actions follow the same format.

```dart
@immutable
class MyAction extends PayloadAction<Payload, Meta, Error> {
  const PayloadAction({
    Payload payload,
    Meta meta,
    Error error,
  }) : super(
    payload: payload,
    meta: meta,
    error: error,
  );
}
```

Another, simpler, example is this class I took from the example. It's the action I dispatch when I want to complete a TODO item when I tap on one:

```dart
@immutable
class CompleteTodo extends PayloadAction<Todo, dynamic, dynamic> {
  const CompleteTodo(Todo todo) : super(payload: todo);
}
```

### `AsyncThunk` abstract class

Again, no `createAsyncThunk` like in the original but an abstract class. This is an application of the template method design pattern so I'll allow you to specify your operation that returns a `Future` by overriding the `run` method and I'll take care of dispatching actions as the state of your `Future` evolves.

The next example shows a thunk that fetches a list of todos from the [JSON Placeholder API](https://jsonplaceholder.typicode.com) and transforms the json it receives into a model class.

```dart
@immutable
class FetchTodos extends AsyncThunk<FetchTodos, AppState, void, List<Todo>> {
  @override
  Future<List<Todo>> run() async {
    final response = await http.get('${Config.apiBaseUrl}/todos');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Todo.fromJson(e)).toList();
  }
}
```

### Convenience exports

Just like the original `redux-toolkit` I re-exported some useful functions and even entire libraries just for convenience.

- `nanoid` -> An inlined copy of nanoid/nonsecure. Generates a non-cryptographically-secure random ID string.
- [`reselect`](https://github.com/brianegan/reselect_dart) -> Everything that `reselect` exports I export for convenience.
