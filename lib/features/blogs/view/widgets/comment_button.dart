import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/blog_interaction_viewmodel.dart';
import '../comments_bottomsheet.dart';

class CommentButton extends ConsumerWidget {
  final String blogId;
  final String userId;
  final String userName;
  final double size;

  const CommentButton({
    required this.blogId,
    required this.userId,
    required this.userName,
    this.size = 24.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(commentsProvider(blogId));

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => CommentBottomSheet(
            blogId: blogId,
            userId: userId,
            userName: userName,
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.comment_outlined,
            size: size,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            comments.when(
              data: (comments) => comments.length.toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            style: TextStyle(
              fontSize: size * 0.75,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
