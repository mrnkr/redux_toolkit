library redux_toolkit;

import 'package:redux/redux.dart';

typedef CaseReducer<State, Action> = State Function(State, Action);
typedef DefaultCaseReducer<State> = State Function(State);
typedef BuilderCallback<State> = Function(ActionReducerMapBuilder<State>);

abstract class ActionReducerMapBuilder<State> {
  ActionReducerMapBuilder<State> addCase<Action>(CaseReducer<State, Action> reducer);
  ActionReducerMapBuilder<State> addDefaultCase(DefaultCaseReducer<State> reducer);
  ActionReducerMap<State> build();
}

abstract class ActionReducerMap<State> {
  CaseReducer<State, dynamic> getReducerForAction(Type action);
}

class _ActionReducerMapBuilder<State> implements ActionReducerMapBuilder<State>, ActionReducerMap<State> {
  final Map<Type, CaseReducer<State, dynamic>> _actionsMap = {};
  CaseReducer<State, dynamic> _defaultCaseReducer = (state, action) => state;

  ActionReducerMapBuilder<State> addCase<Action>(CaseReducer<State, Action> reducer) {
    _actionsMap[Action] = (state, action) => reducer(state, action);
    return this;
  }

  ActionReducerMapBuilder<State> addDefaultCase(DefaultCaseReducer<State> reducer) {
    _defaultCaseReducer = (state, action) => reducer(state);
    return this;
  }

  ActionReducerMap<State> build() {
    return this;
  }

  CaseReducer<State, dynamic> getReducerForAction(Type action) {
    if (_actionsMap.containsKey(action)) {
      return _actionsMap[action];
    }

    return _defaultCaseReducer;
  }
}

Reducer<State> createReducer<State>(State initialState, BuilderCallback<State> builderCallback) {
  final builder = _ActionReducerMapBuilder<State>();
  builderCallback(builder);
  final actionReducerMap = builder.build();

  return (state, action) {
    if (state == null) {
      state = initialState;
    }

    return actionReducerMap.getReducerForAction(action.runtimeType)(state, action);
  };
}
