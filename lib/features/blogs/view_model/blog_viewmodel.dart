import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view_model/category_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/blog_model.dart';


final blogsProvider = StreamProvider<List<Blog>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('blogs')
      .where('category', whereIn: user.selectedTopics)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((doc) => Blog.fromMap(doc.data(), doc.id)).toList());
});

final userBlogsProvider = StreamProvider<List<Blog>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('blogs')
      .where('authorId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((doc) => Blog.fromMap(doc.data(), doc.id)).toList());
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

final filteredBlogsProvider = StreamProvider<List<Blog>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final blogsStream = ref.watch(blogsProvider.stream);

  return blogsStream.map((blogs) {
    if (selectedCategory == null) return blogs;
    return blogs.where((blog) => blog.category == selectedCategory).toList();
  });
});

// Categories provider
final categoriesProvider = StreamProvider<List<String>>((ref) {
  return FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snap) => snap.docs.map((doc) => doc.id).toList());
});