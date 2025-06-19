import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/repositories/auth_viewmodel_provider.dart';
import '../../data/model/blog_model.dart';
import '../../view_model/blog_interaction_viewmodel.dart';
import '../../../../widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedPostsScreen extends ConsumerWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view saved posts')),
      );
    }
    final savedPostsAsync = ref.watch(savedPostsProvider(user.uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: savedPostsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (savedIds) {
          if (savedIds.isEmpty) {
            return const Center(child: Text('No saved posts yet.'));
          }
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('blogs')
                .where(FieldPath.documentId, whereIn: savedIds)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No saved posts found.'));
              }
              final blogs = snapshot.data!.docs
                  .map((doc) => Blog.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                  .toList();
              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    post: blogs[index],
                    onTap: () {
                      Navigator.pushNamed(context, '/post-detail', arguments: blogs[index]);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
