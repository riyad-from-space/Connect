import 'package:connect/core/constants/colours.dart';
import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:connect/features/auth/data/models/user_model.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:connect/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/chat/data/services/chat_service.dart';
import 'package:connect/features/chat/view/chat_screen.dart';


class ProfileScreen extends ConsumerWidget {
  final String? userId;
  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider).value;
    final userFuture = userId == null
        ? Future.value(currentUser)
        : Future<UserModel?>.microtask(() async {
            final snap = await FirebaseFirestore.instance.collection('users').doc(userId).get();
            if (!snap.exists) return null;
            return UserModel.fromMap(snap.data()!);
          });
    final userBlogsAsync = ref.watch(userBlogsProvider);

    return FutureBuilder<UserModel?>(
      future: userFuture,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Please login to view profile')),
          );
        }

        // Determine if this is the current user's profile
        final isOwnProfile = userId == null || (currentUser != null && userId == currentUser.uid);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Gradient Avatar as Container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: KColor.purpleGradient,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        user.firstName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${user.username}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Posts Section
              Expanded(
                child: userBlogsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (blogs) {
                    if (blogs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No posts yet',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            // In the empty state, only show the create post button if it's your own profile
                            if (isOwnProfile) ...[
                              const SizedBox(height: 8),
                              Center(
                                child: SubmitButton(
                                  isEnabled: true,
                                  onSubmit: () => Navigator.pushNamed(context, '/create-post'),
                                  buttonText: 'Create Your First Post',
                                  message: '',
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    // In the ListView.builder, use isOwnProfile for delete logic (already present)
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: blogs.length,
                      itemBuilder: (context, index) {
                        final blog = blogs[index];
                        if (isOwnProfile) {
                          return Dismissible(
                            key: Key(blog.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              ref.read(blogControllerProvider).deleteBlog(blog.id);
                            },
                            child: PostCard(
                              post: blog,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/post-detail',
                                  arguments: blog,
                                );
                              },
                            ),
                          );
                        } else {
                          return PostCard(
                            post: blog,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/post-detail',
                                arguments: blog,
                              );
                            },
                          );
                        }
                      },
                    ); // End ListView.builder
                  },
                ),
              ),
              // Add chat button if not own profile
              if (!isOwnProfile && currentUser != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                    onPressed: () async {
                      final chatService = ChatService();
                      final chatId = await chatService.getOrCreateChatId(currentUser.uid, user.uid);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatId: chatId,
                            otherUserName: user.firstName,
                            currentUserId: currentUser.uid,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ); // End Scaffold
      },
    );
  }
}




















