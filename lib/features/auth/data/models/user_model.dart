class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final List<String> selectedTopics;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.selectedTopics = const [],
    required this.createdAt,
  });

  // Convert UserModel to JSON
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'selectedTopics': selectedTopics,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert JSON to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      username: map['username'],
      email: map['email'],
      selectedTopics: List<String>.from(map['selectedTopics']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
