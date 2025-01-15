class Topic {
  final String name;
  bool isSelected;

  Topic({required this.name, this.isSelected = false});

  factory Topic.fromJson(String name) {
    return Topic(name: name);
  }
}
