import 'package:example/config.dart';
import 'package:example/modules/app_reducer.dart';
import 'package:example/modules/app_state.dart';
import 'package:example/my_app.dart';
import 'package:flutter/material.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initialize();

  final store = await configureStore<AppState>((builder) {
    builder.withReducer(reducer);
    builder.withPreloadedState(AppState.initialState());

    if (Config.reduxDevtoolsEnabled) {
      builder.usingDevtools(Config.reduxDevtoolsUrl);
    }
  });

  runApp(MyApp(store));
}
