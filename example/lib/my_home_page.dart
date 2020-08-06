import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useEffect;
import 'package:flutter_redux/flutter_redux.dart';

import 'actions.dart';
import 'app_state.dart';
import 'todo.dart';

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
        converter: (store) => store.state.todos,
        builder: (context, todos) => ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, idx) => Text(todos[idx].title)),
      ),
    );
  }
}
