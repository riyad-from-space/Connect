import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<String> selectedCategories;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.selectedCategories = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'selectedCategories': selectedCategories,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      // Handle selectedCategories
      List<String> categories = [];
      if (map['selectedCategories'] != null) {
        if (map['selectedCategories'] is List) {
          categories = (map['selectedCategories'] as List)
              .map((item) => item.toString())
              .toList();
        }
      }

      // Handle createdAt
      DateTime dateTime = DateTime.now();
      if (map['createdAt'] != null) {
        if (map['createdAt'] is Timestamp) {
          dateTime = (map['createdAt'] as Timestamp).toDate();
        } else if (map['createdAt'] is String) {
          dateTime = DateTime.parse(map['createdAt']);
        }
      }

      return UserModel(
        id: map['id']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        selectedCategories: categories,
        createdAt: dateTime,
      );
    } catch (e) {
      print('Error creating UserModel from map: $e');
      print('Map data: $map');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, selectedCategories: $selectedCategories, createdAt: $createdAt)';
  }
}
