import 'package:connect/core/constants/colours.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel_impl.dart';
import 'package:connect/features/chat/view/chat_list_screen.dart';
import 'package:connect/features/home/view/user_search_delegate.dart';
import 'package:connect/features/user_profile/view/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/post_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    ref.watch(categoryInitializerProvider);
    final userAsync = ref.watch(authStateProvider);
    final blogsAsync = ref.watch(feedProvider);
    final trendingBlogsAsync = ref.watch(trendingBlogsProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: Text('Please login to continue.')),
      );
    }

    // Set initial selected category to onboarding topic if not set
    userAsync.whenData((userData) {
      if (selectedCategory == null &&
          userData != null &&
          userData.selectedTopics.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(selectedCategoryProvider.notifier).state =
              userData.selectedTopics.first;
        });
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
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
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: KColor.purpleGradient,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        user.firstName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/create-post'),
                    child: Text(
                      'Create Post',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(color: Color(0xff9C27B0), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            // Categories chips with Trending as the first chip
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  height: 40,
                  child: categoriesAsync.when(
                    loading: () => Center(child: CircularProgressIndicator(color: Color(0xff9C27B0))),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Error loading categories: $e', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                      ),
                    ),
                    data: (categories) {
                      final allCategories = ['Trending', ...categories];
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: allCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = allCategories[index];
                          final isTrending = cat == 'Trending';
                          final isSelected = isTrending
                              ? selectedCategory == 'Trending'
                              : selectedCategory == cat;
                          return Center(
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: Color(0xff9C27B0),
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              onSelected: (_) {
                                ref.read(selectedCategoryProvider.notifier).state = isTrending ? 'Trending' : (isSelected ? null : cat);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            // Show trending blogs if Trending is selected, else show normal blogs
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: (selectedCategory == 'Trending')
                  ? trendingBlogsAsync.when(
                      loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                      error: (e, _) => SliverFillRemaining(
                        child: Center(
                          child: Text('Error loading trending: $e', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                        ),
                      ),
                      data: (blogs) {
                        if (blogs.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.trending_up, size: 64, color: colorScheme.outline.withOpacity(0.3)),
                                  const SizedBox(height: 16),
                                  Text('No trending blogs yet.', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
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
                    )
                  : blogsAsync.when(
                      loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                      error: (e, _) => SliverFillRemaining(
                        child: Center(
                          child: Text('Error loading posts: $e', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                        ),
                      ),
                      data: (blogs) {
                        if (blogs.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.article_outlined, size: 64, color: colorScheme.outline.withOpacity(0.3)),
                                  const SizedBox(height: 16),
                                  Text(
                                    selectedCategory == null ? 'No posts from followed users.' : 'No posts in this category',
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
      ),
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
                icon: Icon(Icons.home, color: Color(0xff9C27B0)),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search, color: Color(0xff9C27B0)),
                onPressed: () async {
                  showSearch(
                    context: context,
                    delegate: UserSearchDelegate(ref),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Color(0xff9C27B0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatListScreen(currentUserId: user.uid),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.bookmark_outline, color: Color(0xff9C27B0)),
                onPressed: () {
                  Navigator.pushNamed(context, '/saved-posts');
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: Color(0xff9C27B0)),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
