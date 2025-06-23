import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/model/blog_model.dart';
import '../../../../widgets/category_chip.dart';

class PostDetailScreen extends StatelessWidget {
  final Blog post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                post.title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
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
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (post.category.isNotEmpty) ...[
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CategoryChip(
                      label: post.category,
                      isSelected: true,
                      onTap: () {},
                      selectedColor: Theme.of(context).primaryColor.withOpacity(0.8),
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