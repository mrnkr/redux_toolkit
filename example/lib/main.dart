import 'package:flutter/material.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

import 'app_state.dart';
import 'config.dart';
import 'my_app.dart';
import 'reducer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initialize();

  final store = await configureStore<AppState>((builder) {
    builder.withReducer(reducer);
    builder.withPreloadedState(AppState(loading: false, todos: List.unmodifiable([])));

    if (Config.reduxDevtoolsEnabled) {
      builder.usingDevtools(Config.reduxDevtoolsUrl);
    }
  });

  runApp(MyApp(store));
}
