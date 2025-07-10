import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colours.dart';
import '../../view_model/blog_interaction_viewmodel.dart';

class CommentBottomSheet extends ConsumerStatefulWidget {
  final String blogId;
  final String userId;
  final String userName;

  const CommentBottomSheet({
    required this.blogId,
    required this.userId,
    required this.userName,
    super.key,
  });

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
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? KColor.white
            : KColor.darkSurface,
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
                        decoration:
                            const BoxDecoration(color: Color(0xffE4E4E9)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    commentsAsyncValue.when(
                      data: (comments) {
                        if (comments.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 32.0),
                              child: Text(
                                  'No comments yet. Be the first to comment!'),
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
                                      child: Text(
                                          comment.userName[0].toUpperCase()),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                comment.userName,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _getTimeAgo(
                                                    comment.timestamp.toDate()),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            comment.content,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (comment.userId == widget.userId)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          ref
                                              .read(blogInteractionController)
                                              .deleteComment(
                                                  widget.blogId, comment.id);
                                        },
                                      ),
                                    Consumer(
                                      builder: (context, ref, _) {
                                        final hasReacted = ref
                                                .watch(
                                                    hasUserReactedToCommentProvider({
                                                  'blogId': widget.blogId,
                                                  'commentId': comment.id,
                                                  'userId': widget.userId,
                                                }))
                                                .asData
                                                ?.value ??
                                            false;
                                        final reactionsCount = ref
                                                .watch(
                                                    commentReactionsCountProvider({
                                                  'blogId': widget.blogId,
                                                  'commentId': comment.id,
                                                }))
                                                .asData
                                                ?.value ??
                                            0;
                                        return Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                hasReacted
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: hasReacted
                                                    ? KColor.primary
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                ref
                                                    .read(
                                                        blogInteractionController)
                                                    .toggleCommentReaction(
                                                      widget.blogId,
                                                      comment.id,
                                                      widget.userId,
                                                    );
                                              },
                                            ),
                                            Text(reactionsCount.toString()),
                                          ],
                                        );
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
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text('Error loading comments: $error'),
                      ),
                    ),
                    Row(
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final reactionsCount = ref
                                .watch(reactionsCountProvider(widget.blogId));
                            return TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => UsersReactedBottomSheet(
                                      blogId: widget.blogId),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.people, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                      'View all reactions (${reactionsCount.asData?.value}' ??
                                          '0' ')'),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? KColor.white
                      : KColor.darkSurface,
                  border: Border(
                    top: BorderSide(color: KColor.grey.withOpacity(0.2)),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

class UsersReactedBottomSheet extends ConsumerWidget {
  final String blogId;
  const UsersReactedBottomSheet({required this.blogId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactionsStream = FirebaseFirestore.instance
        .collection('reactions')
        .doc(blogId)
        .collection('userReactions')
        .snapshots();
    return SizedBox(
      height: 400,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users who reacted'),
          automaticallyImplyLeading: false,
        ),
        body: StreamBuilder(
          stream: reactionsStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No reactions yet.'));
            }
            final userIds = snapshot.data!.docs
                .map((doc) => doc['userId'] as String)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Reacted by',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userIds.length,
                    itemBuilder: (context, index) {
                      final userId = userIds[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .get(),
                        builder: (context, userSnap) {
                          if (userSnap.connectionState ==
                              ConnectionState.waiting) {
                            return const ListTile(
                              leading: CircleAvatar(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                              title: Text('Loading...'),
                            );
                          }
                          if (!userSnap.hasData || !userSnap.data!.exists) {
                            return ListTile(
                              leading:
                                  const CircleAvatar(child: Icon(Icons.person)),
                              title: Text(userId),
                            );
                          }
                          final data =
                              userSnap.data!.data() as Map<String, dynamic>;
                          final name = (data['firstName'] ?? '') +
                              (data['lastName'] != null
                                  ? ' ' + data['lastName']
                                  : '');
                          final avatarLetter =
                              (data['firstName'] ?? 'U').toString().isNotEmpty
                                  ? data['firstName'][0].toUpperCase()
                                  : 'U';
                          return ListTile(
                            leading: CircleAvatar(child: Text(avatarLetter)),
                            title: Text(name.isNotEmpty ? name : userId),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
