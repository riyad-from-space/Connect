import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/auth/data/models/user_model.dart';
import 'package:connect/features/user_profile/view/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchDelegate extends SearchDelegate<UserModel?> {
  final WidgetRef ref;
  UserSearchDelegate(this.ref);

  @override
  String get searchFieldLabel => 'Search users by name';

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    return _buildUserResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type a username to search.'));
    }
    return _buildUserResults(context);
  }

  Widget _buildUserResults(BuildContext context) {
    final searchLower = query.toLowerCase();
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchLower)
          .where('username', isLessThanOrEqualTo: searchLower + '\uf8ff')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found.'));
        }
        final users = snapshot.data!.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
        return ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(user.firstName[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
              ),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text('@${user.username}'),
              onTap: () {
                close(context, user);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(userId: user.uid),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
