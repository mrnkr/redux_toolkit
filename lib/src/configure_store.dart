import 'dart:async';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

/// Type used for the argument passed to `configureStore`.
typedef StoreBuilderCallback<State> = Function(StoreBuilder<State> builder);

/// A friendly abstraction over the standard way of instantiating the `Store` class.
/// Build a store with `redux_thunk` and opt-in to `redux_dev_tools` and `redux_remote_devtools`.
/// 
/// ### Example
/// 
/// ```dart
/// final store = await configureStore<AppState>((builder) {
///   builder.withReducer(reducer);
///   builder.withPreloadedState(AppState.initialState());
/// 
///   if (Config.reduxDevtoolsEnabled) {
///     builder.usingDevtools(Config.reduxDevtoolsUrl);
///   }
/// });
/// ```
Future<Store<State>> configureStore<State>(StoreBuilderCallback<State> builderCallback) {
  final builder = _StoreBuilder<State>();
  builderCallback(builder);
  return builder.build();
}

/// Interface used to build `Store` instances with `createStore`.
abstract class StoreBuilder<State> {
  /// Defines the `initialState`.
  StoreBuilder<State> withPreloadedState(State preloadedState);

  /// Defines the root reducer of tour `Store`.
  StoreBuilder<State> withReducer(Reducer<State> reducer);

  /// Adds a middleware to the end of your middleware array.
  /// 
  /// Important: The `RemoteDevToolsMiddleware`, should you choose to use it,
  /// is handled separately and is therefore always kept in the end of the array
  /// as the guys at `redux_remote_devtools` recommend.
  StoreBuilder<State> withMiddleware(Middleware<State> middleware);

  /// Receives the IP address in which you are running the `remote-devtools`
  /// server. It will assert that you provide a valid IP address and port like
  /// `127.0.0.1:5000`.
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
