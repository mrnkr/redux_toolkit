import 'package:example/model/todo.dart';
import 'package:example/modules/todos/actions.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

final todosReducer = createReducer<List<Todo>>(
    List.unmodifiable([]),
    (builder) => builder
        .addCase<Fulfilled<FetchTodos, List<Todo>, void>>(
            (state, action) => action.payload)
        .addCase<CompleteTodo>((state, action) => List.unmodifiable(state
            .map<Todo>((e) =>
                e.id == action.payload.id ? e.copyWith(completed: true) : e)
            .toList())));
