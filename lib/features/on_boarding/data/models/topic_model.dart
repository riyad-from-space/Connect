class Topic {
  final String id;
  final String name;
  bool isSelected;

  Topic({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory Topic.fromMap(Map<String, dynamic> data, String documentId) {
    return Topic(
      id: documentId,
      name: data['name'] ?? '',
      isSelected: false,
    );
  }
}
