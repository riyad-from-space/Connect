import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';



import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/blog_interaction_viewmodel.dart';

final _optimisticReactionProvider = StateProvider.family<bool?, Map<String, String>>((ref, params) => null);

class ReactionButton extends ConsumerWidget {
  final String blogId;
  final String userId;
  final double size;
  

  const ReactionButton({
    required this.blogId,
    required this.userId,
    this.size = 24.0,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactionsCount = ref.watch(reactionsCountProvider(blogId));
    final optimistic = ref.watch(_optimisticReactionProvider({'blogId': blogId, 'userId': userId}));
    final hasUserReactedAsync = ref.watch(hasUserReactedProvider({'blogId': blogId, 'userId': userId}));
    final hasUserReacted = optimistic ?? hasUserReactedAsync.asData?.value ?? false;

    return Row(
      children: [
        InkWell(
          onTap: () {
            ref.read(_optimisticReactionProvider({'blogId': blogId, 'userId': userId}).notifier).state = !hasUserReacted;
            ref.read(blogInteractionController).toggleReaction(blogId, userId).whenComplete(() {
              ref.read(_optimisticReactionProvider({'blogId': blogId, 'userId': userId}).notifier).state = null;
            });
          },
          child: AnimatedScale(
            scale: hasUserReacted ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              hasUserReacted ? Icons.favorite : Icons.favorite_border,
              color: KColor.primary,
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
