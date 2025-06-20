import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/chat/data/models/chat_models.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get or create a chat between two users
  Future<String> getOrCreateChatId(String userId1, String userId2) async {
    final members = [userId1, userId2]..sort();
    final query = await _firestore
        .collection('chats')
        .where('members', arrayContains: userId1)
        .get();
    for (final doc in query.docs) {
      final data = doc.data();
      final docMembers = List<String>.from(data['members'] ?? []);
      if (docMembers.length == 2 && docMembers.contains(userId1) && docMembers.contains(userId2)) {
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
  }

  // Send a message
  Future<void> sendMessage(String chatId, Message message) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add(message.toMap());
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message.text,
      'lastMessageTime': message.timestamp,
      'lastMessageSenderId': message.senderId,
    });
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
}
