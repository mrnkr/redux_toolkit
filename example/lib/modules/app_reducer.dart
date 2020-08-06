import 'package:example/modules/app_state.dart';
import 'package:example/modules/status/reducer.dart';
import 'package:example/modules/todos/reducer.dart';

AppState reducer(AppState state, dynamic action) {
  return AppState(
      status: statusReducer(state.status, action),
      todos: todosReducer(state.todos, action));
}
