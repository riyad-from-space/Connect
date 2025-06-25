import 'package:cloud_firestore/cloud_firestore.dart';

class FollowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followUser(String currentUserId, String targetUserId) async {
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
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
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
  }

  Future<List<String>> getFollowingUserIds(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('following')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
