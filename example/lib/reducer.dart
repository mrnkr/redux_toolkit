import 'package:redux_toolkit/redux_toolkit.dart';

import 'actions.dart';
import 'app_state.dart';
import 'todo.dart';

final reducer = createReducer<AppState>(
    AppState(loading: false, todos: List.unmodifiable([])),
    (builder) => builder
        .addCase<Fulfilled<FetchTodos, List<Todo>, void>>(
            (state, action) => AppState(loading: false, todos: action.payload))
        .addMatcher(
            (action) => action.runtimeType.toString().startsWith('Pending'),
            (state, action) =>
                AppState(loading: true, todos: List.unmodifiable([]))));
