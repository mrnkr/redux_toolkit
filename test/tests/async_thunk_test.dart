import 'dart:convert';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

import '../fakes/test_thunks.dart';

class MockStore extends Mock implements Store<int> {}

void main() {
  group('async thunk', () {
    Store<int> store;

    setUp(() {
      store = MockStore();
    });

    test('should dispatch Pending<StringLength, String>', () async {
      final thunk = StringLength('hello');
      await thunk.call(store);
      verify(store.dispatch(argThat(isA<Pending<StringLength, String>>())));
    });

    test('should dispatch Fulfilled<StringLength, int, String>', () async {
      final thunk = StringLength('hello');
      await thunk.call(store);
      verify(
          store.dispatch(argThat(isA<Fulfilled<StringLength, int, String>>())));
    });

    test('should dispatch Pending<EpicFail, String>', () async {
      final thunk = EpicFail('hello');
      await thunk.call(store);
      verify(store.dispatch(argThat(isA<Pending<EpicFail, String>>())));
    });

    test('should dispatch Rejected<EpicFail, String, dynamic>', () async {
      final thunk = EpicFail('hello');
      await thunk.call(store);
      verify(
          store.dispatch(argThat(isA<Rejected<EpicFail, String, dynamic>>())));
    });

    test('should dispatch all actions with the same meta.requestId', () async {
      final thunk = StringLength('hello');
      await thunk.call(store);
      final dispatched = verify(store.dispatch(captureAny)).captured;
      final requestId = dispatched.first.meta.requestId;
      expect(
          dispatched
              .map((action) => action.meta.requestId)
              .every((element) => element == requestId),
          isTrue);
    });

    test('should dispatch serializable actions', () async {
      final thunk = StringLength('hello');
      await thunk.call(store);
      verify(store.dispatch(argThat(predicate(
          (arg) => jsonDecode(jsonEncode(arg)) is Map<String, dynamic>))));
    });

    test('should have serializable metadata', () async {
      final meta = Meta(null, '3c26a440-d9a7-4fc2-ac2a-8524de6f1f19');
      final actual = meta.toJson();
      final expected = {
        'arg': null,
        'requestId': '3c26a440-d9a7-4fc2-ac2a-8524de6f1f19',
      };
      expect(actual, equals(expected));
    });
  });
}
