import 'package:redux/redux.dart';
import 'package:redux_toolkit/redux_toolkit.dart';
import 'package:test/test.dart';

import 'test_actions.dart';
import 'test_state.dart';

class SingleTestThunk {}

class DoubleTestThunk {}

void main() {
  group('create reducer', () {
    final TestState initialState = TestState(items: List.unmodifiable([]));

    Reducer<TestState> testStateReducer;
    Reducer<int> listReducer;
    Reducer<bool> statusReducer;

    setUp(() {
      testStateReducer = createReducer<TestState>(initialState, (builder) {
        builder
            .addCase<RequestItemsAction>(
                (state, action) => state.copyWith(isLoading: true))
            .addCase<FetchItemsSuccessfulAction>((state, action) =>
                state.copyWith(isLoading: false, items: action.payload))
            .addCase<FetchItemsErrorAction>((state, action) =>
                state.copyWith(isLoading: false, error: action.error));
      });

      listReducer = createReducer<int>(0, (builder) {
        builder
            .addCase<Fulfilled<SingleTestThunk, String, void>>(
                (state, action) => 1)
            .addCase<Fulfilled<DoubleTestThunk, String, void>>(
                (state, action) => 2);
      });

      statusReducer = createReducer<bool>(false, (builder) {
        builder
            .addMatcher(
                (action) => action.runtimeType.toString().startsWith('Pending'),
                (state, action) => true)
            .addMatcher(
                (action) =>
                    action.runtimeType.toString().startsWith('Fulfilled'),
                (state, action) => false);
      });
    });

    test('should yield the initialState', () {
      final result = testStateReducer(initialState, SomeUnhandledAction());
      expect(result, equals(initialState));
    });

    test('should yield a loading state', () {
      final result = testStateReducer(initialState, RequestItemsAction());
      expect(result.isLoading, isTrue);
    });

    test('should yield a non loading state (FetchItemsSuccessfulAction)', () {
      final items = List<Item>.unmodifiable([
        Item(id: 1, title: "Item 1"),
        Item(id: 2, title: "Item 2"),
      ]);

      final prevState = initialState.copyWith(isLoading: true);
      final result = testStateReducer(
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
      final result = testStateReducer(
          prevState,
          FetchItemsSuccessfulAction(
            payload: items,
          ));

      expect(result.items, equals(items));
    });

    test('should yield a non loading state, (FetchItemsErrorAction)', () {
      final error = Exception("Hehe you failed");

      final prevState = initialState.copyWith(isLoading: true);
      final result = testStateReducer(
          prevState,
          FetchItemsErrorAction(
            error: error,
          ));

      expect(result.isLoading, isFalse);
    });

    test('should yield an error state', () {
      final error = Exception("Hehe you failed");

      final prevState = initialState.copyWith(isLoading: true);
      final result = testStateReducer(
          prevState,
          FetchItemsErrorAction(
            error: error,
          ));

      expect(result.error, equals(error));
    });

    test('should yield list with only SingleTestThunk', () {
      final result = listReducer(
        0,
        Fulfilled<SingleTestThunk, String, void>('SingleTestThunk', null),
      );

      expect(result, equals(1));
    });

    test('should yield list with only DoubleTestThunk', () {
      final result = listReducer(
        0,
        Fulfilled<DoubleTestThunk, String, void>('DoubleTestThunk', null),
      );

      expect(result, equals(2));
    });

    test('should yield that the thing is loading', () {
      final result = statusReducer(false, Pending<SingleTestThunk, void>(null));
      expect(result, isTrue);
    });
    
    test('should yield that the thing is not loading', () {
      final result = statusReducer(true, Fulfilled<SingleTestThunk, String, void>('SingleTestThunk', null));
      expect(result, isFalse);
    });
  });
}
