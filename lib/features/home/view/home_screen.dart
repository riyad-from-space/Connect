import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel_impl.dart';
import 'package:connect/features/user_profile/view/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connect/features/home/view/user_search_delegate.dart';
import 'package:connect/features/chat/view/chat_list_screen.dart';
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to continue.')),
      );
    }

    // Set initial selected category to onboarding topic if not set
    userAsync.whenData((userData) {
      if (selectedCategory == null && userData != null && userData.selectedTopics.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(selectedCategoryProvider.notifier).state = userData.selectedTopics.first;
        });
      }
    });

    return Scaffold(
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
                    child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      user.firstName[0].toUpperCase(),
                      style: theme.textTheme.headlineLarge
                    ),
                  ),
                  ),
                  // Container(
                  //   height: screenHeight * 0.05,
                  //   width: screenWidth * 0.10,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
                  //   ),
                  //   child: InkWell(
                  //     onTap: () {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(
                  //           content: Text(
                  //             'Under Development!',
                  //             style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
                  //           ),
                  //           backgroundColor: colorScheme.secondary,
                  //         ),
                  //       );
                  //     },
                  //     child: Icon(
                  //       Icons.notifications_none_rounded,
                  //       color: colorScheme.onSurface,
                  //     ),
                  //   ),
                  // ),
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
                        
                       
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = cat == selectedCategory;
                          return Center(
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: colorScheme.primary,
                              backgroundColor: colorScheme.surfaceVariant,
                              onSelected: (_) {
                                ref.read(selectedCategoryProvider.notifier).state = isSelected ? null : cat;
                              },
                              // labelStyle: theme.textTheme.bodyMedium?.copyWith(
                              //   color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                              // ),
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
              padding: const EdgeInsets.all(8),
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
                onPressed: () async {
                  showSearch(
                    context: context,
                    delegate: UserSearchDelegate(ref),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: colorScheme.onSurfaceVariant),
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


