import 'package:example/modules/app_state.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

final _selectTodos = (AppState state) => state.todos;
final selectAllTodos = createSelector1(_selectTodos, (todos) => todos);
