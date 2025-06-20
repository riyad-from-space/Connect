import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> members;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;

  Chat({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
  });

  factory Chat.fromMap(String id, Map<String, dynamic> map) {
    return Chat(
      id: id,
      members: List<String>.from(map['members'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] is Timestamp && map['lastMessageTime'] != null)
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      lastMessageSenderId: map['lastMessageSenderId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'lastMessageSenderId': lastMessageSenderId,
    };
  }
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] is Timestamp && map['timestamp'] != null)
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
