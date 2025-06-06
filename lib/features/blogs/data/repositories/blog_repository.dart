import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/blog_model.dart';
import '../model/category_model.dart';

class BlogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Posts
  Future<void> createPost(BlogPost post) async {
    await _firestore.collection('posts').doc(post.id).set(post.toMap());
  }

  Stream<List<BlogPost>> getPostsByCategories(List<String> categories) {
    final query = _firestore.collection('posts');

    if (categories.isEmpty) {
      return query
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => BlogPost.fromMap({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
      });
    }

    return query
        .where('categories', arrayContainsAny: categories)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BlogPost.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    });
  }

  Future<BlogPost> getPostById(String postId) async {
    final doc = await _firestore.collection('posts').doc(postId).get();
    return BlogPost.fromMap({
      'id': doc.id,
      ...doc.data() ?? {},
    });
  }

  // Categories
  Future<void> createCategory(Category category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .set(category.toMap());
  }

  Stream<List<Category>> getAllCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Category.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    });
  }

  Future<List<Category>> getCategoriesByIds(List<String> categoryIds) async {
    final snapshots = await Future.wait(
      categoryIds
          .map((id) => _firestore.collection('categories').doc(id).get()),
    );

    return snapshots
        .where((doc) => doc.exists)
        .map((doc) => Category.fromMap({
              'id': doc.id,
              ...doc.data() ?? {},
            }))
        .toList();
  }

  Future<void> deletePost(String id) async {
    await _firestore.collection('posts').doc(id).delete();
  }
}
