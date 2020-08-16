class TestModel {
  final String id;
  final String title;
  final bool completed;

  const TestModel({this.id, this.title, this.completed});

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'completed': completed};
}
