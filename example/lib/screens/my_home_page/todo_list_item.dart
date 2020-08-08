import 'package:example/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;

part 'todo_list_item.g.dart';

@hwidget
Widget todoListItem({Todo todo, void Function(Todo) onTap}) {
  return GestureDetector(
    onTap: () => onTap(todo),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text(todo.title)),
              todo.completed
                  ? Icon(
                      Icons.check,
                      color: Colors.lightGreen.shade600,
                      size: 24.0,
                      semanticLabel: 'Completed',
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    ),
  );
}
