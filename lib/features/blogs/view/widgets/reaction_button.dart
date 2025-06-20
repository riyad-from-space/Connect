import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/blog_interaction_viewmodel.dart';

class ReactionButton extends ConsumerWidget {
  final String blogId;
  final String userId;
  final double size;

  const ReactionButton({
    required this.blogId,
    required this.userId,
    this.size = 24.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactionsCount = ref.watch(reactionsCountProvider(blogId));
    final hasUserReacted = ref.watch(
      hasUserReactedProvider({'blogId': blogId, 'userId': userId}),
    );

    return Row(
      children: [
        InkWell(
          onTap: () {
            ref.read(blogInteractionController).toggleReaction(blogId, userId);
          },
          child: AnimatedScale(
            scale: hasUserReacted.when(
              data: (hasReacted) => hasReacted ? 1.2 : 1.0,
              loading: () => 1.0,
              error: (_, __) => 1.0,
            ),
            duration: const Duration(milliseconds: 200),
            child: Icon(
              hasUserReacted.when(
                data: (hasReacted) =>
                    hasReacted ? Icons.favorite : Icons.favorite_border,
                loading: () => Icons.favorite_border,
                error: (_, __) => Icons.favorite_border,
              ),
              color: hasUserReacted.when(
                data: (hasReacted) => hasReacted ? KColor.primary : Colors.grey,
                loading: () => Colors.grey,
                error: (_, __) => Colors.grey,
              ),
              size: size,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          reactionsCount.when(
            data: (count) => count.toString(),
            loading: () => '...',
            error: (_, __) => '0',
          ),
          style: TextStyle(
            fontSize: size * 0.75,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
