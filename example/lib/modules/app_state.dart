import 'package:example/model/todo.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_state.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class AppState {
  final Map<String, String> status;
  final List<Todo> todos;

  AppState({this.status, this.todos});

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);
  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}
