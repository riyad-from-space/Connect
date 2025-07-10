import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/blogs/data/model/blog_model.dart';

class FeedRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Blog>> getFeedForUser(String userId) async {
    try {
      // Get the list of user IDs the current user is following
      final followingSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('following')
          .get();
      final followingIds = followingSnapshot.docs.map((doc) => doc.id).toList();
      if (followingIds.isEmpty) return [];

      // Get posts from followed users
      final blogsSnapshot = await _firestore
          .collection('blogs')
          .where('authorId', whereIn: followingIds)
          .orderBy('createdAt', descending: true)
          .get();
      return blogsSnapshot.docs
          .map((doc) => Blog.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('ERROR FETCHING FEED FOR USER: \\${e.toString()}');
      throw Exception('Failed to fetch feed. Please try again.');
    }
  }
}
