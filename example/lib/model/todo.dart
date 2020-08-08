import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'todo.g.dart';

@immutable
@JsonSerializable()
class Todo {
  final int id;
  final String title;
  final bool completed;

  const Todo({
    this.id,
    this.title,
    this.completed,
  });

  Todo copyWith({String title, bool completed}) => Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed);

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
