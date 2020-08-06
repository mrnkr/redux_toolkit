import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:redux_toolkit/redux_toolkit.dart';
import 'package:http/http.dart' as http;

import 'app_state.dart';
import 'config.dart';
import 'todo.dart';

@immutable
class FetchTodos extends AsyncThunk<FetchTodos, AppState, void, List<Todo>> {
  @override
  Future<List<Todo>> run() async {
    final response = await http.get('${Config.apiBaseUrl}/todos');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Todo.fromJson(e)).toList();
  }
}
