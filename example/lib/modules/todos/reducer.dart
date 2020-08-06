import 'package:example/modules/todos/actions.dart';
import 'package:example/todo.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

final todosReducer = createReducer(
    List.unmodifiable([]),
    (builder) => builder.addCase<Fulfilled<FetchTodos, List<Todo>, void>>(
        (state, action) => action.payload));
