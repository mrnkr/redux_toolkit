import 'package:example/modules/app_state.dart';
import 'package:example/modules/todos/actions.dart';
import 'package:example/modules/todos/selectors.dart';
import 'package:example/todo.dart';
import 'package:example/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useEffect;
import 'package:flutter_redux/flutter_redux.dart';


class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FetchTodos());
      return;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: StoreConnector<AppState, List<Todo>>(
        converter: (store) => selectAllTodos(store.state),
        builder: (context, todos) => ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, idx) => TodoListItem(todo: todos[idx])),
      ),
    );
  }
}
