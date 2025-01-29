
import 'package:cloud_firestore/cloud_firestore.dart';


import '../model/blog_model.dart';

class BlogPostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBlogPost(BlogPost blogPost) async {
    try {
      await _firestore.collection('blog_posts').doc(blogPost.id).set(blogPost.toMap());
      print("Blog post saved: ${blogPost.toMap()}");
    } catch (e) {
      print("Error adding blog post: $e");
    }
  }

  Future<void> updateBlogPost(BlogPost blogPost) async {
    try {
      await _firestore.collection('blog_posts').doc(blogPost.id).update(blogPost.toMap());
      print("Blog post updated: ${blogPost.title}");
    } catch (e) {
      print("Error updating blog post: $e");
    }
  }

  Future<void> deleteBlogPost(String id) async {
    try {
      await _firestore.collection('blog_posts').doc(id).delete();
      print("Blog post deleted: $id");
    } catch (e) {
      print("Error deleting blog post: $e");
    }
  }

  Stream<List<BlogPost>> getBlogPosts() {
    return _firestore.collection('blog_posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return BlogPost.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }
}
