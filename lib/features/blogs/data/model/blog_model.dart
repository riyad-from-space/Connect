class BlogPost {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final List<String> categories;
  final DateTime createdAt;
  final String previewContent;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.categories,
    required this.createdAt,
    String? previewContent,
  }) : previewContent = previewContent ??
            (content.length > 150
                ? content.substring(0, 150) + '...'
                : content);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'categories': categories,
      'createdAt': createdAt.toIso8601String(),
      'previewContent': previewContent,
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      categories: List<String>.from(map['categories'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      previewContent: map['previewContent'],
    );
  }
}
