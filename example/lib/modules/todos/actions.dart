import 'dart:convert';

import 'package:example/model/todo.dart';
import 'package:example/modules/app_state.dart';
import 'package:example/config.dart';
import 'package:meta/meta.dart';
import 'package:redux_toolkit/redux_toolkit.dart';
import 'package:http/http.dart' as http;

@immutable
class FetchTodos extends AsyncThunk<FetchTodos, AppState, void, List<Todo>> {
  @override
  Future<List<Todo>> run() async {
    final response = await http.get('${Config.apiBaseUrl}/todos');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Todo.fromJson(e)).toList();
  }
}
