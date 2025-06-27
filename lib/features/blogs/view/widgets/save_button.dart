import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveButton extends ConsumerWidget {
  final String blogId;
  final String userId;
  final double size;
  final bool isSaved;
  final VoidCallback onTap;

  const SaveButton({
    required this.blogId,
    required this.userId,
    required this.isSaved,
    required this.onTap,
    this.size = 24.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved
              ? Color(0xff9C27B0)
              : colorScheme.onSurface.withOpacity(0.5),
          size: size,
        ),
        onPressed: onTap,
        tooltip: isSaved ? 'Unsave' : 'Save',
      ),
    );
  }
}
