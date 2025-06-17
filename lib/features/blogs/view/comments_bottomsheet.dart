import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/colours.dart';
import '../../../core/constants/text_style.dart';
import '../view_model/blog_interaction_viewmodel.dart';

class CommentBottomSheet extends ConsumerStatefulWidget {
  final String blogId;
  final String userId;
  final String userName;

  const CommentBottomSheet({
    required this.blogId,
    required this.userId,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends ConsumerState<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentEmpty = true;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsyncValue = ref.watch(commentsProvider(widget.blogId));

    return SizedBox(
      height: 680,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 3,
                        width: 50,
                        decoration: const BoxDecoration(color: Color(0xffE4E4E9)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    commentsAsyncValue.when(
                      data: (comments) {
                        if (comments.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 32.0),
                              child: Text('No comments yet. Be the first to comment!'),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(comment.userName[0].toUpperCase()),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                comment.userName,
                                                style: KTextStyle.subtitle1.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: KColor.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _getTimeAgo(comment.timestamp.toDate()),
                                                style: KTextStyle.subtitle1.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            comment.content,
                                            style: KTextStyle.for_description,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (comment.userId == widget.userId)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          ref.read(blogInteractionController)
                                              .deleteComment(widget.blogId, comment.id);
                                        },
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                              ],
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text('Error loading comments: $error'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: KColor.grey.withOpacity(0.2)),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        onChanged: (text) {
                          setState(() {
                            _isCommentEmpty = text.trim().isEmpty;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Write your comment...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: _isCommentEmpty ? KColor.grey : KColor.primary,
                      ),
                      onPressed: _isCommentEmpty
                          ? null
                          : () {
                              final content = _commentController.text.trim();
                              if (content.isNotEmpty) {
                                ref.read(blogInteractionController).addComment(
                                      widget.blogId,
                                      widget.userId,
                                      widget.userName,
                                      content,
                                    );
                                _commentController.clear();
                                setState(() {
                                  _isCommentEmpty = true;
                                });
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
