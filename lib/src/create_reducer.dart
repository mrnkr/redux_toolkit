import 'package:redux/redux.dart';

typedef ActionMatcher<Action> = bool Function(Action action);
typedef CaseReducer<State, Action> = State Function(State state, Action action);
typedef DefaultCaseReducer<State> = State Function(State state);
typedef BuilderCallback<State> = Function(
    ActionReducerMapBuilder<State> builder);

abstract class ActionReducerMapBuilder<State> {
  ActionReducerMapBuilder<State> addCase<Action>(
      CaseReducer<State, Action> reducer);
  ActionReducerMapBuilder<State> addMatcher<Action>(
      ActionMatcher<Action> actionMatcher, CaseReducer<State, Action> reducer);
  ActionReducerMapBuilder<State> addDefaultCase(
      DefaultCaseReducer<State> reducer);
  ActionReducerMap<State> build();
}

abstract class ActionReducerMap<State> {
  CaseReducer<State, dynamic> getReducerForAction(dynamic action);
}

class _ActionReducerMapBuilder<State>
    implements ActionReducerMapBuilder<State>, ActionReducerMap<State> {
  final Map<Type, CaseReducer<State, dynamic>> _actionsMap = {};
  final Map<ActionMatcher, CaseReducer<State, dynamic>> _actionMatchers = {};
  CaseReducer<State, dynamic> _defaultCaseReducer = (state, action) => state;

  ActionReducerMapBuilder<State> addCase<Action>(
      CaseReducer<State, Action> reducer) {
    _actionsMap[Action] = (state, action) => reducer(state, action);
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
    if (_actionsMap.containsKey(action.runtimeType)) {
      return _actionsMap[action.runtimeType];
    }

    for (final entry in _actionMatchers.entries) {
      if (entry.key(action)) {
        return entry.value;
      }
    }

    return _defaultCaseReducer;
  }
}

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
