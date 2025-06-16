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
            backgroundColor: Colors.white,
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
                    border: Border.all(color: const Color(0xffD6E5EA)),
                  ),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Under Development!'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xff7E7F88),
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
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Error loading categories: $e',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ),
                  data: (categories) {
                    if (categories.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('No categories available'),
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
                          onSelected: (_) {
                            ref.read(selectedCategoryProvider.notifier).state =
                                isSelected ? null : cat;
                                
                          },
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
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Error loading posts: $e',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
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
                          Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            selectedCategory == null
                                ? 'No posts available'
                                : 'No posts in this category',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
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
                          Navigator.pushNamed(
                            context,
                            '/post-detail',
                            arguments: post,
                          );
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
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xffF2F9FB),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/Home.png'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Under Development!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: Ink(
                  child: Image.asset(
                    'assets/images/8666693_search_icon.png',
                    width: screenWidth * 0.06,
                    height: screenHeight * 0.03,
                    color: const Color(0xff5C5D67),
                  ),
                ),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Under Development!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlogAddEditScreen()),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xffA76FFF),
                    radius: 30,
                    child: Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                ),
              ),
              label: 'Floating',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Under Development!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: Image.asset('assets/images/Bookmark.png')),
              label: 'Save',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/Path_33946.png'),
              label: 'Settings',
            ),
          ],
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.normal),
        ),
      );
    
  }
}


