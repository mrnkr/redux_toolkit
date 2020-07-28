import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

import 'test_thunks.dart';

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
      verify(store.dispatch(argThat(isA<Fulfilled<StringLength, int, String>>())));
    });

    test('should dispatch Pending<EpicFail, String>', () async {
      final thunk = EpicFail('hello');
      await thunk.call(store);
      verify(store.dispatch(argThat(isA<Pending<EpicFail, String>>())));
    });
    
    test('should dispatch Rejected<EpicFail, String, dynamic>', () async {
      final thunk = EpicFail('hello');
      await thunk.call(store);
      verify(store.dispatch(argThat(isA<Rejected<EpicFail, String, dynamic>>())));
    });
  });
}
