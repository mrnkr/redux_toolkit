import 'package:meta/meta.dart';

class Item {
  final int id;
  final String title;

  Item({
    @required this.id,
    @required this.title,
  });
}

class TestState {
  final bool isLoading;
  final List<Item> items;
  final Exception error;

  const TestState({
    this.isLoading = false,
    @required this.items,
    this.error,
  });

  TestState copyWith({
    isLoading,
    items,
    error,
  }) {
    return TestState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }
}
