import 'dart:async';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './action.dart';
import './nanoid.dart';

@immutable
class Meta<T> {
  final T arg;
  final String requestId;

  const Meta(this.arg, this.requestId);
}

@immutable
class Pending<T, M> extends PayloadAction<dynamic, Meta<M>, dynamic> {
  Pending(M meta, String requestId) : super(meta: Meta(meta, requestId));
}

@immutable
class Fulfilled<T, P, M> extends PayloadAction<P, Meta<M>, dynamic> {
  Fulfilled(P payload, M meta, String requestId) : super(payload: payload, meta: Meta(meta, requestId));
}

@immutable
class Rejected<T, M, E> extends PayloadAction<dynamic, Meta<M>, E> {
  Rejected(M meta, E error, String requestId) : super(meta: Meta(meta, requestId), error: error);
}

@immutable
abstract class AsyncThunk<Self, State, Payload, Result> implements CallableThunkAction<State> {
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
