import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_toolkit/redux_toolkit.dart';
import 'package:test/test.dart';

import '../fakes/test_actions.dart';

class MockMiddleware extends Mock implements MiddlewareClass {}

void main() {
  group('configure store', () {
    test('should return an instance of Store', () async {
      final store = await configureStore<dynamic>(
          (builder) => builder.withReducer((state, action) => null));
      expect(store, isA<Store<dynamic>>());
    });

    test('should have a state equal to the preloaded state', () async {
      final store = await configureStore<int>((builder) =>
          builder.withReducer((state, action) => 2).withPreloadedState(1));
      expect(store.state, equals(1));
    });

    test('should run the provided middleware when dispatching', () async {
      final middleware = MockMiddleware();
      final store = await configureStore<int>((builder) =>
          builder.withReducer((state, action) => 2).withMiddleware(middleware));

      store.dispatch(SomeUnhandledAction());
      verify(middleware(argThat(isA<Store<int>>()), any, any)).called(1);
    });
  });
}
