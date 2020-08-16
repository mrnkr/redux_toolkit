import 'dart:convert';

import 'package:test/test.dart';

import '../fakes/test_actions.dart';
import '../fakes/test_model.dart';

void main() {
  group('payload action', () {
    test('should be json serializable', () {
      final action = TestPayloadAction(
          payload: 'Serializable payload',
          meta: 'Serializable meta',
          error: 'Serializable error');
      final actual = jsonDecode(jsonEncode(action));
      final expected = {
        'payload': 'Serializable payload',
        'meta': 'Serializable meta',
        'error': 'Serializable error',
      };
      expect(actual, equals(expected));
    });

    test('should serialize nested objects within payload', () {
      final action = TestPayloadAction(
          payload: TestModel(
              id: '9f4772ab-8756-47e1-89a0-69d3e7a056d5',
              title: 'Lorem ipsum dolor sit amet',
              completed: false),
          meta: 'Serializable meta',
          error: 'Serializable error');
      final actual = jsonDecode(jsonEncode(action));
      final expected = {
        'payload': {
          'id': '9f4772ab-8756-47e1-89a0-69d3e7a056d5',
          'title': 'Lorem ipsum dolor sit amet',
          'completed': false
        },
        'meta': 'Serializable meta',
        'error': 'Serializable error',
      };
      expect(actual, equals(expected));
    });

    test('should serialize nested objects within meta', () {
      final action = TestPayloadAction(
          payload: 'Serializable payload',
          meta: TestModel(
              id: '9f4772ab-8756-47e1-89a0-69d3e7a056d5',
              title: 'Lorem ipsum dolor sit amet',
              completed: false),
          error: 'Serializable error');
      final actual = jsonDecode(jsonEncode(action));
      final expected = {
        'payload': 'Serializable payload',
        'meta': {
          'id': '9f4772ab-8756-47e1-89a0-69d3e7a056d5',
          'title': 'Lorem ipsum dolor sit amet',
          'completed': false
        },
        'error': 'Serializable error',
      };
      expect(actual, equals(expected));
    });

    test('should serialize nested objects within errors', () {
      final action = TestPayloadAction(
          payload: 'Serializable payload',
          meta: 'Serializable meta',
          error: TestModel(
              id: '9f4772ab-8756-47e1-89a0-69d3e7a056d5',
              title: 'Lorem ipsum dolor sit amet',
              completed: false));
      final actual = jsonDecode(jsonEncode(action));
      final expected = {
        'payload': 'Serializable payload',
        'meta': 'Serializable meta',
        'error': {
          'id': '9f4772ab-8756-47e1-89a0-69d3e7a056d5',
          'title': 'Lorem ipsum dolor sit amet',
          'completed': false
        },
      };
      expect(actual, equals(expected));
    });
  });
}
