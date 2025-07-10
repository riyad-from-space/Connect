import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/core/constants/colours.dart';
import 'package:connect/core/widgets/buttons/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/chat_models.dart';
import '../data/services/chat_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  final String currentUserId;
  const ChatListScreen({required this.currentUserId, super.key});

  Future<Map<String, String>> _getUserInfo(String userId) async {
    final snap =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snap.exists) {
      final data = snap.data();
      if (data != null &&
          data['firstName'] != null &&
          data['lastName'] != null) {
        final name = "${data['firstName']} ${data['lastName']}";
        final initials = data['firstName'][0].toUpperCase();
        return {'name': name, 'initials': initials};
      }
    }
    return {'name': userId, 'initials': '?'};
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatService chatService = ChatService();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const CustomBackButton(),
        ),
        title: const Text('Chats'),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: chatService.userChatsStream(currentUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data!;
          final nonEmptyChats =
              chats.where((c) => c.lastMessage.trim().isNotEmpty).toList();
          if (nonEmptyChats.isEmpty) {
            return const Center(child: Text('No chats yet.'));
          }
          return ListView.separated(
            itemCount: nonEmptyChats.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final chat = nonEmptyChats[index];
              final otherUserId =
                  chat.members.firstWhere((id) => id != currentUserId);
              return FutureBuilder<Map<String, String>>(
                future: _getUserInfo(otherUserId),
                builder: (context, userSnap) {
                  final displayName = userSnap.data?['name'] ?? otherUserId;
                  final initials = userSnap.data?['initials'] ?? '?';
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: KColor.purpleGradient,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(displayName),
                    subtitle: Text(chat.lastMessage),
                    trailing: Text(
                      TimeOfDay.fromDateTime(chat.lastMessageTime)
                          .format(context),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatId: chat.id,
                            otherUserName: displayName,
                            currentUserId: currentUserId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
