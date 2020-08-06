import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'todo.dart';

part 'app_state.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class AppState {
  final bool loading;
  final List<Todo> todos;
  AppState({this.loading, this.todos});

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);
  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}
