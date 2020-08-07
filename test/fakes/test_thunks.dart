import 'dart:async';
import 'package:redux_toolkit/redux_toolkit.dart';

class StringLength extends AsyncThunk<StringLength, int, String, int> {
  const StringLength(String payload) : super(payload);

  @override
  Future<int> run() => Future.sync(() => payload.length);
}

class EpicFail extends AsyncThunk<EpicFail, int, String, int> {
  const EpicFail(String payload) : super(payload);

  @override
  Future<int> run() => Future.error(Exception('hehe'));
}
