import 'dart:async';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './action.dart';

class Pending<T, M> extends PayloadAction<dynamic, M, dynamic> {
  const Pending(M meta) : super(meta: meta);
}

class Fulfilled<T, P, M> extends PayloadAction<P, M, dynamic> {
  const Fulfilled(P payload, M meta) : super(payload: payload, meta: meta);
}

class Rejected<T, M, E> extends PayloadAction<dynamic, M, E> {
  const Rejected(M meta, E error) : super(meta: meta, error: error);
}

abstract class AsyncThunk<Self, State, Payload, Result> implements CallableThunkAction<State> {
  final Payload payload;
  
  const AsyncThunk([this.payload]);

  Future<Result> run();

  @override
  Future<void> call(Store<State> store) async {
    store.dispatch(Pending<Self, Payload>(payload));
    try {
      final result = await run();
      store.dispatch(Fulfilled<Self, Result, Payload>(result, payload));
    } catch (err) {
      store.dispatch(Rejected<Self, Payload, dynamic>(payload, err));
    }
  }
}
