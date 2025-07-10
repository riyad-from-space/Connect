import 'package:cloud_firestore/cloud_firestore.dart';

class FollowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      // Add targetUserId to currentUser's following
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .set({'followedAt': FieldValue.serverTimestamp()});
      // Add currentUserId to targetUser's followers
      await _firestore
          .collection('users')
          .doc(targetUserId)
          .collection('followers')
          .doc(currentUserId)
          .set({'followedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      print('ERROR FOLLOWING USER: \\${e.toString()}');
      throw Exception('Failed to follow user. Please try again.');
    }
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .delete();
      await _firestore
          .collection('users')
          .doc(targetUserId)
          .collection('followers')
          .doc(currentUserId)
          .delete();
    } catch (e) {
      print('ERROR UNFOLLOWING USER: \\${e.toString()}');
      throw Exception('Failed to unfollow user. Please try again.');
    }
  }

  Future<List<String>> getFollowingUserIds(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('following')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('ERROR FETCHING FOLLOWING USER IDS: \\${e.toString()}');
      throw Exception('Failed to fetch following users. Please try again.');
    }
  }
}
