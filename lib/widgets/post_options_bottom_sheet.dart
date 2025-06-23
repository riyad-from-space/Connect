import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/text_styles.dart';
import '../features/blogs/data/model/blog_model.dart';
import '../features/blogs/view_model/blog_viewmodel.dart';
import '../features/blogs/view_model/blog_interaction_viewmodel.dart';
import 'package:connect/features/chat/data/services/chat_service.dart';
import 'package:connect/features/chat/view/chat_screen.dart';

class PostOptionsBottomSheet extends ConsumerWidget {
  final Blog post;
  final String userId;
  final bool isAuthor;
  final bool initialSaveState;

  const PostOptionsBottomSheet({
    Key? key,
    required this.post,
    required this.userId,
    required this.isAuthor,
    required this.initialSaveState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 390,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 100, 8, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).brightness == Brightness.light ? KColor.white : KColor.darkSurface,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 14),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Save/Unsave option
                  StatefulBuilder(
                    builder: (context, setState) {
                      return GestureDetector(
                        onTap: () async {
                          try {
                            await ref.read(blogInteractionController).toggleSave(post.id, userId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(initialSaveState ? 'Post unsaved' : 'Post saved'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(initialSaveState ? 'Failed to unsave post' : 'Failed to save post'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          initialSaveState ? 'Unsave Post' : 'Save Post',
                           style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                        ),
                      );
                    },
                  ),
                  // Chat option (if not author)
                  if (!isAuthor) ...[
                    const SizedBox(height: 14),
                    Container(height: 1, color: Color(0xffEFEFEF)),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () async {
                        final chatService = ChatService();
                        final chatId = await chatService.getOrCreateChatId(userId, post.authorId);
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                chatId: chatId,
                                otherUserName: post.authorName,
                                currentUserId: userId,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('Chat with Author',  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),),
                    ),
                  ],

                  if (isAuthor) ...[
                    const SizedBox(height: 14),
                    Container(height: 1, color: const Color(0xffEFEFEF)),
                    const SizedBox(height: 14),
                    // Edit option
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context, 
                          '/edit-post',
                          arguments: post
                        );
                      },
                      child: Text('Edit Blog',  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),),
                    ),
                    const SizedBox(height: 14),
                    Container(height: 1, color: const Color(0xffEFEFEF)),
                    const SizedBox(height: 14),
                    // Delete option
                    GestureDetector(
                      onTap: () {
                        ref.read(blogControllerProvider).deleteBlog(post.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Blog deleted!')
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Delete Blog', style:Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Cancel button
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 20),
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:Theme.of(context).brightness == Brightness.light ? KColor.white : KColor.darkSurface,
            ),
            child: Center(
              child: Text('Cancel',  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),)
            ),
          ),
        ),
      ],
    );
  }
}
