import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String id;
  final String title;
  final String content;
  final String category;    // Single category
  final String authorId;
  final String authorName;
  final int commentCount;
  final Timestamp createdAt;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorId,
    required this.authorName,
    this.commentCount = 0,
    required this.createdAt,
  });

  factory Blog.fromMap(Map<String, dynamic> data, String id) {
    return Blog(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      commentCount: data['commentCount'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'authorId': authorId,
      'authorName': authorName,
      'commentCount': commentCount,
      'createdAt': createdAt,
    };
  }
}