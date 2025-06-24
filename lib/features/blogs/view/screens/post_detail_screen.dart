import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/category_chip.dart';
import '../../data/model/blog_model.dart';

class PostDetailScreen extends StatelessWidget {
  final Blog post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  String _formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(post.title, style: theme.textTheme.headlineLarge),
              background: Container(
                decoration: BoxDecoration(
                  gradient: KColor.purpleGradient,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          post.authorName.isNotEmpty
                              ? post.authorName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                              style: theme.textTheme.headlineLarge!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              _formatDate(post.createdAt.toDate()),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    post.content,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (post.category.isNotEmpty) ...[
                    Text('Category',
                        style: theme.textTheme.headlineLarge!
                            .copyWith(fontSize: 24)),
                    const SizedBox(height: 8),
                    CategoryChip(
                      label: post.category,
                      isSelected: true,
                      onTap: () {},
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
