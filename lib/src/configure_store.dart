import 'dart:async';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

typedef StoreBuilderCallback<State> = Function(StoreBuilder<State> builder);

Future<Store<State>> configureStore<State>(StoreBuilderCallback<State> builderCallback) {
  final builder = _StoreBuilder<State>();
  builderCallback(builder);
  return builder.build();
}

abstract class StoreBuilder<State> {
  StoreBuilder<State> withPreloadedState(State preloadedState);
  StoreBuilder<State> withReducer(Reducer<State> reducer);
  StoreBuilder<State> withMiddleware(Middleware<State> middleware);
  StoreBuilder<State> usingDevtools(String devToolsIpAddr);
}

class _StoreBuilder<State> implements StoreBuilder<State> {
  static final _ipAddrRegex = RegExp(r'^([0-9]{1,3}\.){3}[0-9]{1,3}:[0-9]{1,5}$');

  State _preloadedState;
  Reducer<State> _reducer;
  List<Middleware<State>> _middleware = [thunkMiddleware];
  bool _devTools = false;
  String _devToolsIpAddr;

  StoreBuilder<State> withReducer(Reducer<State> reducer) {
    _reducer = reducer;
    return this;
  }

  StoreBuilder<State> withPreloadedState(State preloadedState) {
    _preloadedState = preloadedState;
    return this;
  }

  StoreBuilder<State> withMiddleware(Middleware<State> middleware) {
    _middleware.add(middleware);
    return this;
  }

  StoreBuilder<State> usingDevtools(String devToolsIpAddr) {
    assert(_ipAddrRegex.hasMatch(devToolsIpAddr));

    _devTools = true;
    _devToolsIpAddr = devToolsIpAddr;

    return this;
  }

  Future<Store<State>> build() async {
    assert(_reducer != null);

    if (_devTools) {
      var remoteDevtools = RemoteDevToolsMiddleware(_devToolsIpAddr);
      _middleware.add(remoteDevtools);
      final store = DevToolsStore<State>(_reducer, middleware: _middleware, initialState: _preloadedState);
      remoteDevtools.store = store;
      await remoteDevtools.connect();
      return store;
    }

    final store = Store<State>(_reducer, middleware: _middleware, initialState: _preloadedState);
    return store;
  }
}
