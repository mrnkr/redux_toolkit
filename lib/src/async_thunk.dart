import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './action.dart';
import './nanoid.dart';

/// Metadata used by `AsyncThunk`
@immutable
class Meta<T> {
  final T arg;
  final String requestId;

  const Meta(this.arg, this.requestId);

  Map<String, dynamic> toJson() =>
      {'requestId': requestId, 'arg': jsonDecode(jsonEncode(arg))};
}

/// Action that gets dispatched when an `AsyncThunk`
/// starts being processed.
///
/// Will come with the `payload` passed to the thunk
/// within its `meta` member.
@immutable
class Pending<T, M> extends PayloadAction<void, Meta<M>, void> {
  Pending(M meta, String requestId) : super(meta: Meta(meta, requestId));
}

/// Action that gets dispatched when an `AsyncThunk`
/// finishes successfully.
///
/// Will have the `payload` that was initially passed
/// to the thunk within its `meta` and the result
/// of the operation in its `payload`.
@immutable
class Fulfilled<T, P, M> extends PayloadAction<P, Meta<M>, void> {
  Fulfilled(P payload, M meta, String requestId)
      : super(payload: payload, meta: Meta(meta, requestId));
}

/// Action that gets dispatched when an `AsyncThunk`
/// finishes with an error.
///
/// Will have the error that occurred in its `error`
/// member and within its `meta` you'll find the
/// `payload` that was initially passed to the thunk.
@immutable
class Rejected<T, M, E> extends PayloadAction<void, Meta<M>, E> {
  Rejected(M meta, E error, String requestId)
      : super(meta: Meta(meta, requestId), error: error);
}

/// Abstraction to make thunks that just deal with a `Future`
/// adhere to a standard.
///
/// Before the `Future` starts processing this will dispatch a `Pending` action.
///
/// After the `Future` resolves successfully this will dispatch a `Fulfilled` action.
///
/// After the `Future` fails this will dispatch a `Rejected` action.
///
///
/// ### Example
///
/// ```dart
/// @immutable
/// class FetchTodos extends AsyncThunk<FetchTodos, AppState, void, List<Todo>> {
///   @override
///   Future<List<Todo>> run() async {
///     final response = await http.get('https://jsonplaceholder.typicode.com/todos');
///     final list = jsonDecode(response.body) as List<dynamic>;
///     return list.map((e) => Todo.fromJson(e)).toList();
///   }
/// }
/// ```
@immutable
abstract class AsyncThunk<Self, State, Payload, Result>
    implements CallableThunkAction<State> {
  final Payload payload;

  const AsyncThunk([this.payload]);

  Future<Result> run();

  @override
  Future<void> call(Store<State> store) async {
    final id = generate();
    store.dispatch(Pending<Self, Payload>(payload, id));
    try {
      final result = await run();
      store.dispatch(Fulfilled<Self, Result, Payload>(result, payload, id));
    } catch (err) {
      store.dispatch(Rejected<Self, Payload, dynamic>(payload, err, id));
    }
  }
}
