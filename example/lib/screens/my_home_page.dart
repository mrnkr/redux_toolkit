import 'package:example/model/todo.dart';
import 'package:example/modules/app_state.dart';
import 'package:example/modules/todos/actions.dart';
import 'package:example/screens/my_home_page/todo_list_item.dart';
import 'package:example/widgets/loading.dart';
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
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) => Loading(
                loading: state.status['FetchTodos'] == 'Pending',
                child: state.todos.length > 0
                    ? ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, idx) =>
                            TodoListItem(todo: state.todos[idx]))
                    : Center(
                        child: const Text('Empty list'),
                      ),
              )),
    );
  }
}
