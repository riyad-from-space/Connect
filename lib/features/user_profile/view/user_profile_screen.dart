import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/core/constants/colours.dart';
import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:connect/features/auth/data/models/user_model.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/auth/data/repositories/follow_repository.dart';
import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:connect/features/chat/data/services/chat_service.dart';
import 'package:connect/features/chat/view/chat_screen.dart';
import 'package:connect/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(authStateProvider).value;
    final userFuture = userId == null
        ? Future.value(currentUser)
        : Future<UserModel?>.microtask(() async {
            final snap = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
            if (!snap.exists) return null;
            return UserModel.fromMap(snap.data()!);
          });
    // Use correct provider for profile posts
    final userBlogsAsync = userId == null
        ? ref.watch(userBlogsProvider)
        : ref.watch(profileBlogsProvider(userId!));

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
        final isOwnProfile = userId == null ||
            (currentUser != null && userId == currentUser.uid);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Profile',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Gradient Avatar as Container
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: KColor.purpleGradient,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        user.firstName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${user.username}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Followers/Following counts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('followers')
                              .get(),
                          builder: (context, snapshotFollowers) {
                            final followersCount =
                                snapshotFollowers.data?.docs.length ?? 0;
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => UserListDialog(
                                        userId: user.uid,
                                        type: 'followers',
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Followers: $followersCount',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection('following')
                                      .get(),
                                  builder: (context, snapshotFollowing) {
                                    final followingCount =
                                        snapshotFollowing.data?.docs.length ??
                                            0;
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => UserListDialog(
                                            userId: user.uid,
                                            type: 'following',
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Following: $followingCount',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 8),
                        if (!isOwnProfile && currentUser != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Follow/Unfollow Button
                                FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.uid)
                                      .collection('following')
                                      .doc(user.uid)
                                      .get(),
                                  builder: (context, snapshot) {
                                    // Use a local variable to track following state for instant UI update
                                    bool isFollowing =
                                        snapshot.data?.exists ?? false;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return SizedBox(
                                          height: 30,
                                          width: 95,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isFollowing
                                                  ? Colors.grey
                                                  : Colors.deepPurple,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              elevation: 0,
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onPressed: () async {
                                              final followRepo =
                                                  FollowRepository();
                                              if (isFollowing) {
                                                await followRepo.unfollowUser(
                                                    currentUser.uid, user.uid);
                                                setState(() {
                                                  isFollowing = false;
                                                });
                                              } else {
                                                await followRepo.followUser(
                                                    currentUser.uid, user.uid);
                                                setState(() {
                                                  isFollowing = true;
                                                });
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  isFollowing
                                                      ? Icons.check
                                                      : Icons.person_add,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isFollowing
                                                      ? 'Following'
                                                      : 'Follow',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                // Chat Button
                                SizedBox(
                                  height: 30,
                                  width: 70, // Match follow button width
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      elevation: 0,
                                      textStyle: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () async {
                                      final chatService = ChatService();
                                      final chatId =
                                          await chatService.getOrCreateChatId(
                                              currentUser.uid, user.uid);
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.chat_bubble_outline,
                                          size:
                                              16, // Match icon size with follow button
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Chat',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Posts Section
              Expanded(
                child: userBlogsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (blogs) {
                    if (blogs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.article_outlined,
                                size: 64, color: Colors.grey[400]),
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
                                  onSubmit: () => Navigator.pushNamed(
                                      context, '/create-post'),
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
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              ref
                                  .read(blogControllerProvider)
                                  .deleteBlog(blog.id);
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
            ],
          ),
        ); // End Scaffold
      },
    );
  }
}

// Add this widget at the bottom of the file:
class UserListDialog extends StatelessWidget {
  final String userId;
  final String type; // 'followers' or 'following'
  const UserListDialog({super.key, required this.userId, required this.type});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(type == 'followers' ? 'Followers' : 'Following'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection(type)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No users'));
            }
            final userIds = snapshot.data!.docs.map((doc) => doc.id).toList();
            return FutureBuilder<List<DocumentSnapshot>>(
              future: Future.wait(userIds.map((id) => FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .get())),
              builder: (context, userSnaps) {
                if (userSnaps.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final users = userSnaps.data ?? [];
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userData =
                        users[index].data() as Map<String, dynamic>?;
                    if (userData == null) return const SizedBox();
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                            userData['firstName']?[0]?.toUpperCase() ?? '?'),
                      ),
                      title: Text(
                          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'),
                      subtitle: Text('@${userData['username'] ?? ''}'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProfileScreen(userId: users[index].id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
