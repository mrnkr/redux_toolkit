import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

abstract class Config {
  static YamlMap _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('environment.yaml');
    _config = loadYaml(configString);
  }

  static String get apiBaseUrl => _config['api_base_url'];
  static bool get reduxDevtoolsEnabled => _config['redux_devtools_enabled'];
  static String get reduxDevtoolsUrl => _config['redux_devtools_url'];
}
