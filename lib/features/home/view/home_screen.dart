import 'package:connect/core/constants/text_style.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view/blog_add_edit_screen.dart';
import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel_impl.dart';
import 'package:connect/features/user_profile/view/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/post_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogs = ref.watch(filteredBlogsProvider); // Now a List<Blog>
    final blogsAsync = ref.watch(blogsProvider); // For loading/error
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    ref.watch(categoryInitializerProvider);
    final userAsync = ref.watch(authStateProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Set initial selected category to onboarding topic if not set
    userAsync.whenData((user) {
      if (selectedCategory == null && user != null && user.selectedTopics.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(selectedCategoryProvider.notifier).state = user.selectedTopics.first;
        });
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.scaffoldBackgroundColor,
            pinned: true,
            floating: true,
            stretch: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/Profile.png',
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.12,
                  ),
                ),
                Container(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
                  ),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Under Development!',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
                          ),
                          backgroundColor: colorScheme.secondary,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                height: 40,
                child: categoriesAsync.when(
                  loading: () => Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Error loading categories: $e',
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                      ),
                    ),
                  ),
                  data: (categories) {
                    if (categories.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('No categories available', style: theme.textTheme.bodyMedium),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat == selectedCategory;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: colorScheme.primary.withOpacity(0.2),
                          backgroundColor: colorScheme.surfaceVariant,
                          onSelected: (_) {
                            ref.read(selectedCategoryProvider.notifier).state = isSelected ? null : cat;
                          },
                          labelStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: blogsAsync.when(
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Error loading posts: $e',
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                  ),
                ),
              ),
              data: (_) {
                if (blogs.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined, size: 64, color: colorScheme.outline.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          Text(
                            selectedCategory == null ? 'No posts available' : 'No posts in this category',
                            style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = blogs[index];
                      return PostCard(
                        post: post,
                        onTap: () {
                          Navigator.pushNamed(context, '/post-detail', arguments: post);
                        },
                      );
                    },
                    childCount: blogs.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-post'),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: theme.scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: colorScheme.primary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Search coming soon!', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary)),
                      backgroundColor: colorScheme.secondary,
                    ),
                  );
                },
              ),
              const SizedBox(width: 40), // Space for FAB
              IconButton(
                icon: Icon(Icons.bookmark_outline, color: colorScheme.onSurfaceVariant),
                onPressed: () {
                  Navigator.pushNamed(context, '/saved-posts');
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: colorScheme.onSurfaceVariant),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


