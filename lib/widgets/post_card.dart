import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/theme/text_styles.dart';
import '../features/auth/data/repositories/auth_viewmodel_provider.dart';
import '../features/blogs/data/model/blog_model.dart';
import 'post_options_bottom_sheet.dart';

import '../features/blogs/view/widgets/reaction_button.dart';
import '../features/blogs/view/widgets/comment_button.dart';
import '../features/blogs/view/widgets/save_button.dart';
import '../features/blogs/view_model/blog_viewmodel.dart';
import '../features/blogs/view_model/blog_interaction_viewmodel.dart';

import 'category_chip.dart';

class PostCard extends ConsumerWidget {
  final Blog post;
  final VoidCallback onTap;

  const PostCard({
    Key? key,
    required this.post,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final colorScheme = Theme.of(context).colorScheme;

    if (user == null) {
      return const SizedBox.shrink();
    }    final dateStr = DateFormat('MMM d, yyyy').format(post.createdAt.toDate());
    final isAuthor = user.uid == post.authorId;
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with author info and actions
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorScheme.primary.withOpacity(0.15),
                      child: Text(
                        post.authorName[0].toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorName,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
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
                    IconButton(
                      icon: const Icon(Icons.more_vert),
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
                            }
                          );
                        }
                      },
                    ),
                  ],
                ),
                // Content area (tappable)
                InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.content,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: colorScheme.onSurface.withOpacity(0.85),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // Category chip
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CategoryChip(
                    label: post.category,
                    isSelected: true,
                    onTap: () {},
                    selectedColor: colorScheme.primary.withOpacity(0.15),
                  ),
                ),
                const SizedBox(height: 16),
                // Interaction buttons
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
                      icon: Icon(Icons.auto_awesome,
                        color: colorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/blog-ai', arguments: post);
                      },
                      tooltip: 'AI Features',
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
