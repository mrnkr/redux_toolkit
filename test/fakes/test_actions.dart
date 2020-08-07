import 'package:meta/meta.dart';

import '../fakes/test_state.dart';

abstract class Action<T> {
  final T payload;

  const Action({
    @required this.payload,
  });
}

abstract class ErrorAction<T extends Exception> {
  final T error;

  const ErrorAction({
    @required this.error,
  });
}

class RequestItemsAction {}

class FetchItemsSuccessfulAction extends Action<List<Item>> {
  const FetchItemsSuccessfulAction({ List<Item> payload }) : super(payload: payload);
}

class FetchItemsErrorAction extends ErrorAction<Exception> {
  const FetchItemsErrorAction({ error }) : super(error: error);
}

class SomeUnhandledAction {}
