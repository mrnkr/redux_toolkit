import 'package:flutter/material.dart';

import 'todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;

  const TodoListItem({this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Text(todo.title)),
        ],
      ),
    );
  }
}
