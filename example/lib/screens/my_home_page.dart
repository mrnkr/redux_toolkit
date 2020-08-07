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

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
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
        loading: isLoading,
        child: todos.length > 0
            ? ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, idx) => TodoListItem(todo: todos[idx]))
            : Center(
                child: const Text('Empty list'),
              ),
      ),
    );
  }
}
