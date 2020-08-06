import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useEffect;
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

import 'actions.dart';
import 'app_state.dart';
import 'config.dart';
import 'reducer.dart';
import 'todo.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initialize();

  final store = await configureStore<AppState>((builder) {
    builder.withReducer(reducer);
    builder.withPreloadedState(AppState(loading: false, todos: List.unmodifiable([])));

    if (Config.reduxDevtoolsEnabled) {
      builder.usingDevtools(Config.reduxDevtoolsUrl);
    }
  });

  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store store;

  const MyApp(this.store);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FetchTodos());
      return;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: StoreConnector<AppState, List<Todo>>(
        converter: (store) => store.state.todos,
        builder: (context, todos) => ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, idx) => Text(todos[idx].title)),
      ),
    );
  }
}
