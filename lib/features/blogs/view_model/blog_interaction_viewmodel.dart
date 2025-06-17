import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/comment_model.dart';


// Provider for reactions count
final reactionsCountProvider = StreamProvider.family<int, String>((ref, blogId) {
  return FirebaseFirestore.instance
      .collection('reactions')
      .doc(blogId)
      .collection('userReactions')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});

// Provider to check if current user has reacted
final hasUserReactedProvider = StreamProvider.family<bool, Map<String, String>>((ref, params) {
  final blogId = params['blogId']!;
  final userId = params['userId']!;
  
  return FirebaseFirestore.instance
      .collection('reactions')
      .doc(blogId)
      .collection('userReactions')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.exists);
});

// Provider for comments
final commentsProvider = StreamProvider.family<List<Comment>, String>((ref, blogId) {
  return FirebaseFirestore.instance
      .collection('comments')
      .doc(blogId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => 
          snapshot.docs.map((doc) => Comment.fromMap(doc.data(), doc.id)).toList());
});

// Provider for reactions and comments controller
final blogInteractionController = Provider((ref) => BlogInteractionController());

class BlogInteractionController {
  final _firestore = FirebaseFirestore.instance;

  Future<void> toggleReaction(String blogId, String userId) async {
    final batch = _firestore.batch();
    final reactionRef = _firestore
        .collection('reactions')
        .doc(blogId)
        .collection('userReactions')
        .doc(userId);
    final blogRef = _firestore.collection('blogs').doc(blogId);

    final doc = await reactionRef.get();
    if (doc.exists) {
      batch.delete(reactionRef);
      batch.update(blogRef, {'reactionCount': FieldValue.increment(-1)});
    } else {
      batch.set(reactionRef, {
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      batch.update(blogRef, {'reactionCount': FieldValue.increment(1)});
    }
    
    await batch.commit();
  }

  Future<void> addComment(String blogId, String userId, String userName, String content) async {
    final batch = _firestore.batch();
    
    // Add the comment
    final commentRef = _firestore
        .collection('comments')
        .doc(blogId)
        .collection('comments')
        .doc(); // Auto-generate ID
        
    batch.set(commentRef, {
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
    
    // Update comment count in blog
    final blogRef = _firestore.collection('blogs').doc(blogId);
    batch.update(blogRef, {'commentCount': FieldValue.increment(1)});
    
    await batch.commit();
  }

  Future<void> deleteComment(String blogId, String commentId) async {
    final batch = _firestore.batch();
    
    // Delete the comment
    final commentRef = _firestore
        .collection('comments')
        .doc(blogId)
        .collection('comments')
        .doc(commentId);
        
    batch.delete(commentRef);
    
    // Update comment count in blog
    final blogRef = _firestore.collection('blogs').doc(blogId);
    batch.update(blogRef, {'commentCount': FieldValue.increment(-1)});
    
    await batch.commit();
  }
}
