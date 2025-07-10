import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/chat/data/models/chat_models.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get or create a chat between two users
  Future<String> getOrCreateChatId(String userId1, String userId2) async {
    try {
      final members = [userId1, userId2]..sort();
      final query = await _firestore
          .collection('chats')
          .where('members', arrayContains: userId1)
          .get();
      for (final doc in query.docs) {
        final data = doc.data();
        final docMembers = List<String>.from(data['members'] ?? []);
        if (docMembers.length == 2 &&
            docMembers.contains(userId1) &&
            docMembers.contains(userId2)) {
          return doc.id;
        }
      }
      final doc = await _firestore.collection('chats').add({
        'members': members,
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': '',
      });
      return doc.id;
    } catch (e) {
      print('ERROR GETTING OR CREATING CHAT ID: \\${e.toString()}');
      throw Exception('Failed to get or create chat. Please try again.');
    }
  }

  // Send a message
  Future<void> sendMessage(String chatId, Message message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.text,
        'lastMessageTime': message.timestamp,
        'lastMessageSenderId': message.senderId,
      });
    } catch (e) {
      print('ERROR SENDING MESSAGE: \\${e.toString()}');
      throw Exception('Failed to send message. Please try again.');
    }
  }

  // Stream messages for a chat
  Stream<List<Message>> messagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Stream all chats for a user
  Stream<List<Chat>> userChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chat.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Toggle reaction for a chat message
  Future<void> toggleMessageReaction(
      String chatId, String messageId, String userId) async {
    final reactionRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .collection('reactions')
        .doc(userId);
    final doc = await reactionRef.get();
    if (doc.exists) {
      await reactionRef.delete();
    } else {
      await reactionRef.set({
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Stream for reaction count
  Stream<int> getMessageReactionsCount(String chatId, String messageId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .collection('reactions')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream for whether the user has reacted
  Stream<bool> hasUserReactedToMessage(
      String chatId, String messageId, String userId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .collection('reactions')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}
