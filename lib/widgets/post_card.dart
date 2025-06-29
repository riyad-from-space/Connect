import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/auth/data/repositories/auth_viewmodel_provider.dart';
import '../features/blogs/data/model/blog_model.dart';
import '../features/blogs/view/widgets/comment_button.dart';
import '../features/blogs/view/widgets/reaction_button.dart';
import 'post_options_bottom_sheet.dart';

class PostCard extends ConsumerWidget {
  final Blog post;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    if (user == null) {
      return const SizedBox.shrink();
    }
    final dateStr = DateFormat('MMM d, yyyy').format(post.createdAt.toDate());
    final isAuthor = user.uid == post.authorId;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      shadowColor: Color(0xff9C27B0).withOpacity(0.10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with author info and actions
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Always navigate to the author's profile, not the current user's
                        Navigator.pushNamed(
                          context,
                          '/user-profile',
                          arguments: post.authorId,
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: KColor.purpleGradient,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          post.authorName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Always navigate to the author's profile, not the current user's
                          Navigator.pushNamed(
                            context,
                            '/user-profile',
                            arguments: post.authorId,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.authorName,
                              style: theme.textTheme.headlineLarge!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      splashRadius: 22,
                      onPressed: () async {
                        // Get initial save state without continuous watching
                        final saveState = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('savedPosts')
                            .doc(post.id)
                            .get();

                        if (context.mounted) {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return PostOptionsBottomSheet(
                                  post: post,
                                  userId: user.uid,
                                  isAuthor: isAuthor,
                                  initialSaveState: saveState.exists,
                                );
                              });
                        }
                      },
                    ),
                  ],
                ),
                // Content area (tappable)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onTap,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: theme.textTheme.headlineLarge!.copyWith(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.content,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Color(0xff9C27B0).withOpacity(0.10),
                  thickness: 1,
                  height: 18,
                ),
                // Interaction buttons + category chip in one row
                Row(
                  children: [
                    ReactionButton(
                      blogId: post.id,
                      userId: user.uid,
                    ),
                    const SizedBox(width: 16),
                    CommentButton(
                      blogId: post.id,
                      userId: user.uid,
                      userName: user.firstName,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.auto_awesome,
                        color: Color(0xff9C27B0),
                      ),
                      splashRadius: 20,
                      onPressed: () {
                        Navigator.pushNamed(context, '/blog-ai',
                            arguments: post);
                      },
                      tooltip: 'AI Features',
                    ),
                    const Spacer(),
                    Container(
                      height: 28,
                      constraints:
                          const BoxConstraints(minWidth: 60, maxWidth: 90),
                      decoration: BoxDecoration(
                        color: KColor.primary.withOpacity(0.08),
                        border:
                            Border.all(color: KColor.primary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.label_rounded,
                              size: 14, color: KColor.primary.withOpacity(0.7)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              post.category,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: KColor.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
