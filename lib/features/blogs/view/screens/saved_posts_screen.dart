import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/buttons/back_button.dart';
import '../../../../widgets/post_card.dart';
import '../../../auth/data/repositories/auth_viewmodel_provider.dart';
import '../../data/model/blog_model.dart';
import '../../view_model/blog_interaction_viewmodel.dart';

class SavedPostsScreen extends ConsumerWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view saved posts')),
      );
    }
    final savedPostsAsync = ref.watch(savedPostsProvider(user.uid));
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const CustomBackButton(),
        ),
        title:
            const Text('Saved Posts', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: savedPostsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error loading saved posts: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        data: (savedIds) {
          if (savedIds.isEmpty) {
            return const Center(
              child: Text(
                'No saved posts yet.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('blogs')
                .where(FieldPath.documentId, whereIn: savedIds)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading saved posts: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No saved posts found.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              try {
                final blogs = snapshot.data!.docs
                    .map((doc) {
                      try {
                        final data = doc.data() as Map<String, dynamic>;

                        // Validate required fields with detailed error reporting
                        final requiredFields = {
                          'title': data['title'],
                          'content': data['content'],
                          'authorId': data['authorId'],
                          'authorName': data['authorName'],
                          'category': data['category'],
                          'createdAt': data['createdAt'],
                        };

                        final missingFields = requiredFields.entries
                            .where((entry) => entry.value == null)
                            .map((entry) => entry.key)
                            .toList();

                        if (missingFields.isNotEmpty) {
                          debugPrint(
                              'Skipping invalid blog document ${doc.id}. Missing fields: ${missingFields.join(", ")}');
                          return null;
                        }

                        // Additional type validation
                        if (data['createdAt'] is! Timestamp) {
                          debugPrint(
                              'Invalid createdAt field type in blog ${doc.id}');
                          return null;
                        }

                        return Blog.fromMap(data, doc.id);
                      } catch (e, stackTrace) {
                        debugPrint('Error parsing blog document ${doc.id}: $e');
                        debugPrint(stackTrace.toString());
                        return null;
                      }
                    })
                    .where((blog) => blog != null)
                    .cast<Blog>()
                    .toList();

                if (blogs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No valid saved posts found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: blogs[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/post-detail',
                          arguments: blogs[index],
                        );
                      },
                    );
                  },
                );
              } catch (error, stackTrace) {
                debugPrint('Error processing saved posts: $error');
                debugPrint(stackTrace.toString());
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading saved posts: $error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
