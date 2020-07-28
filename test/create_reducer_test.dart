import 'package:redux/redux.dart';
import 'package:redux_toolkit/redux_toolkit.dart';
import 'package:test/test.dart';

import 'test_actions.dart';
import 'test_state.dart';

void main() {
  group('Create reducer', () {
    Reducer<TestState> reducer;
    final TestState initialState = TestState(items: List.unmodifiable([]));

    setUp(() {
      reducer = createReducer<TestState>(initialState, (builder) {
        builder
            .addCase<RequestItemsAction>(
                (state, action) => state.copyWith(isLoading: true))
            .addCase<FetchItemsSuccessfulAction>((state, action) =>
                state.copyWith(isLoading: false, items: action.payload))
            .addCase<FetchItemsErrorAction>((state, action) =>
                state.copyWith(isLoading: false, error: action.error));
      });
    });

    test('should yield the initialState', () {
      final result = reducer(initialState, SomeUnhandledAction());
      expect(result, equals(initialState));
    });

    test('should yield a loading state', () {
      final result = reducer(initialState, RequestItemsAction());
      expect(result.isLoading, isTrue);
    });

    test('should yield a non loading state (FetchItemsSuccessfulAction)', () {
      final items = List<Item>.unmodifiable([
        Item(id: 1, title: "Item 1"),
        Item(id: 2, title: "Item 2"),
      ]);

      final prevState = initialState.copyWith(isLoading: true);
      final result = reducer(
          prevState,
          FetchItemsSuccessfulAction(
            payload: items,
          ));

      expect(result.isLoading, isFalse);
    });

    test('should yield a state with some items', () {
      final items = List<Item>.unmodifiable([
        Item(id: 1, title: "Item 1"),
        Item(id: 2, title: "Item 2"),
      ]);

      final prevState = initialState.copyWith(isLoading: true);
      final result = reducer(
          prevState,
          FetchItemsSuccessfulAction(
            payload: items,
          ));

      expect(result.items, equals(items));
    });

    test('should yield a non loading state, (FetchItemsErrorAction)', () {
      final error = Exception("Hehe you failed");

      final prevState = initialState.copyWith(isLoading: true);
      final result = reducer(
          prevState,
          FetchItemsErrorAction(
            error: error,
          ));

      expect(result.isLoading, isFalse);
    });

    test('should yield an error state', () {
      final error = Exception("Hehe you failed");

      final prevState = initialState.copyWith(isLoading: true);
      final result = reducer(
          prevState,
          FetchItemsErrorAction(
            error: error,
          ));

      expect(result.error, equals(error));
    });
  });
}
