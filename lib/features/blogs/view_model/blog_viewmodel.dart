
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/blog_model.dart';

// Trending blogs provider: fetches blogs sorted by most liked (reactionCount)
final trendingBlogsProvider = StreamProvider<List<Blog>>((ref) {
  return FirebaseFirestore.instance
      .collection('blogs')
      .orderBy('reactionCount', descending: true)
      .limit(10)
      .snapshots()
      .map((snap) =>
          snap.docs.map((doc) => Blog.fromMap(doc.data(), doc.id)).toList());
});

final blogsProvider = StreamProvider<List<Blog>>((ref) {
  // Fetch all blogs, filtering is handled by filteredBlogsProvider
  return FirebaseFirestore.instance
      .collection('blogs')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) =>
          snap.docs.map((doc) => Blog.fromMap(doc.data(), doc.id)).toList());
});

final userBlogsProvider = StreamProvider<List<Blog>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('blogs')
      .where('authorId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) =>
          snap.docs.map((doc) => Blog.fromMap(doc.data(), doc.id)).toList());
});

final blogControllerProvider = Provider((ref) => BlogController(ref));

class BlogController {
  final Ref _ref;
  final _firestore = FirebaseFirestore.instance;

  BlogController(this._ref);

  Future<void> createBlog(Blog blog) async {
    await _firestore.collection('blogs').doc(blog.id).set(blog.toMap());
  }

  Future<void> updateBlog(Blog blog) async {
    await _firestore.collection('blogs').doc(blog.id).update(blog.toMap());
  }

  Future<void> deleteBlog(String blogId) async {
    await _firestore.collection('blogs').doc(blogId).delete();
  }
}

final filteredBlogsProvider = Provider<List<Blog>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final blogsAsync = ref.watch(blogsProvider);

  return blogsAsync.maybeWhen(
    data: (blogs) {
      if (selectedCategory == null) return blogs;
      return blogs.where((blog) => blog.category == selectedCategory).toList();
    },
    orElse: () => [],
  );
});

// Categories provider
final categoriesProvider = StreamProvider<List<String>>((ref) {
  return FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snap) => snap.docs.map((doc) => doc.id).toList());
});

// Provider to fetch blogs for any user by userId
final profileBlogsProvider =
    StreamProvider.family<List<Blog>, String>((ref, profileUserId) {
  return FirebaseFirestore.instance
      .collection('blogs')
      .where('authorId', isEqualTo: profileUserId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) =>
          snap.docs.map((doc) => Blog.fromMap(doc.data(), doc.id)).toList());
});

// Provider for the feed: posts from followed users, filtered by category
final feedProvider = StreamProvider<List<Blog>>((ref) async* {
  final user = ref.watch(authStateProvider).value;
  final selectedCategory = ref.watch(selectedCategoryProvider);
  if (user == null) {
    yield [];
    return;
  }
  // Get following user IDs
  final followingSnap = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('following')
      .get();
  final followingIds = followingSnap.docs.map((doc) => doc.id).toList();
  if (followingIds.isEmpty) {
    yield [];
    return;
  }
  // Listen to blogs from followed users
  yield* FirebaseFirestore.instance
      .collection('blogs')
      .where('authorId', whereIn: followingIds)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) {
    var blogs =
        snap.docs.map((doc) => Blog.fromMap(doc.data(), doc.id)).toList();
    if (selectedCategory != null) {
      blogs = blogs.where((b) => b.category == selectedCategory).toList();
    }
    return blogs;
  });
});
