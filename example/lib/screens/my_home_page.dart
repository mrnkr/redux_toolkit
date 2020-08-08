import 'package:example/model/todo.dart';
import 'package:example/modules/app_state.dart';
import 'package:example/modules/status/selectors.dart';
import 'package:example/modules/todos/actions.dart';
import 'package:example/modules/todos/selectors.dart';
import 'package:example/screens/my_home_page/todo_list_item.dart';
import 'package:example/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useEffect;
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'my_home_page.g.dart';

@hwidget
Widget myHomePage() {
  final dispatch = useDispatch<AppState>();
  final isLoading = useSelector<AppState, bool>(selectIsPending('FetchTodos'));
  final todos = useSelector<AppState, List<Todo>>(selectAllTodos);

  useEffect(() {
    dispatch(FetchTodos());
    return;
  }, const []);

  return Scaffold(
    appBar: AppBar(
      title: Text('Todos'),
    ),
    body: Loading(
      isLoading: isLoading,
      child: todos.isNotEmpty
          ? ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, idx) => TodoListItem(
                    todo: todos[idx],
                    onTap: (todo) => dispatch(CompleteTodo(todo)),
                  ))
          : Center(
              child: const Text('Empty list'),
            ),
    ),
  );
}
