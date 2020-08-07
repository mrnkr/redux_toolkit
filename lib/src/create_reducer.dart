import 'package:redux/redux.dart';

/// Predicate that given an action returns true
/// if the action matches a certain criteria.
typedef ActionMatcher<Action> = bool Function(Action action);

/// A single case reducer - given a state and a particular
/// action return the corresponding next state.
typedef CaseReducer<State, Action> = State Function(State state, Action action);

/// Default case reducer - given the state return the default
/// next state.
typedef DefaultCaseReducer<State> = State Function(State state);

/// Type used for the callback passed to `createReducer`.
typedef BuilderCallback<State> = Function(
    ActionReducerMapBuilder<State> builder);

/// Interface used to build `Reducer`s with `createReducer`.
abstract class ActionReducerMapBuilder<State> {
  /// If the action is of type `Action` run this code.
  ActionReducerMapBuilder<State> addCase<Action>(
      CaseReducer<State, Action> reducer);

  /// If the matcher (predicate that given an action determines whether it
  /// matches a certain criteria) is true run this code.
  ActionReducerMapBuilder<State> addMatcher<Action>(
      ActionMatcher<Action> actionMatcher, CaseReducer<State, Action> reducer);

  /// If none of the other options were satisfied run this reducer.
  /// 
  /// Defaults to the identity function (returns the previous state)
  ActionReducerMapBuilder<State> addDefaultCase(
      DefaultCaseReducer<State> reducer);
}

/// Abstraction on top of the data structure used
/// to build reducers with `createReducer`.
abstract class ActionReducerMap<State> {
  /// Returns the reducer function for the action that was passed.
  CaseReducer<State, dynamic> getReducerForAction(dynamic action);
}

class _ActionReducerMapBuilder<State>
    implements ActionReducerMapBuilder<State>, ActionReducerMap<State> {
  final Map<String, CaseReducer<State, dynamic>> _actionsMap = {};
  final Map<ActionMatcher, CaseReducer<State, dynamic>> _actionMatchers = {};
  CaseReducer<State, dynamic> _defaultCaseReducer = (state, action) => state;

  ActionReducerMapBuilder<State> addCase<Action>(
      CaseReducer<State, Action> reducer) {
    _actionsMap[Action.toString()] = (state, action) => reducer(state, action);
    return this;
  }

  ActionReducerMapBuilder<State> addMatcher<Action>(
      ActionMatcher<Action> actionMatcher, CaseReducer<State, Action> reducer) {
    _actionMatchers[actionMatcher] = (state, action) => reducer(state, action);
    return this;
  }

  ActionReducerMapBuilder<State> addDefaultCase(
      DefaultCaseReducer<State> reducer) {
    _defaultCaseReducer = (state, action) => reducer(state);
    return this;
  }

  ActionReducerMap<State> build() {
    return this;
  }

  CaseReducer<State, dynamic> getReducerForAction(dynamic action) {
    if (_actionsMap.containsKey(action.runtimeType.toString())) {
      return _actionsMap[action.runtimeType.toString()];
    }

    for (final entry in _actionMatchers.entries) {
      if (entry.key(action)) {
        return entry.value;
      }
    }

    return _defaultCaseReducer;
  }
}

/// Abstraction that allows to create a reducer without
/// writing tons of `if` statements one after the other.
Reducer<State> createReducer<State>(
    State initialState, BuilderCallback<State> builderCallback) {
  final builder = _ActionReducerMapBuilder<State>();
  builderCallback(builder);
  final actionReducerMap = builder.build();

  return (state, action) {
    state = state ?? initialState;
    return actionReducerMap.getReducerForAction(action)(state, action);
  };
}
