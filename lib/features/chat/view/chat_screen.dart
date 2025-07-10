import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/core/constants/colours.dart';
import 'package:connect/core/widgets/buttons/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/chat_models.dart';
import '../data/services/chat_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String otherUserName;
  final String currentUserId;
  const ChatScreen(
      {required this.chatId,
      required this.otherUserName,
      required this.currentUserId,
      super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const CustomBackButton(),
        ),
        title: Text(widget.otherUserName),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final chatState = ref.watch(chatViewModelProvider);
          ref.listen<ChatState>(chatViewModelProvider, (prev, next) {
            if (next.error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to send message: ${next.error}'),
                  backgroundColor: Colors.red,
                ),
              );
              ref.read(chatViewModelProvider.notifier).clearError();
            }
          });
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: _chatService.messagesStream(widget.chatId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data!;
                    if (messages.isEmpty) {
                      return const Center(
                          child: Text('No messages yet. Say hello!'));
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.senderId == widget.currentUserId;
                        if (isMe) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple[400],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(msg.text,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('h:mm a')
                                              .format(msg.timestamp),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Consumer(
                                    builder: (context, ref, _) {
                                      final hasReacted = ref
                                              .watch(
                                                  hasUserReactedToMessageProvider({
                                                'chatId': widget.chatId,
                                                'messageId': msg.id,
                                                'userId': widget.currentUserId,
                                              }))
                                              .asData
                                              ?.value ??
                                          false;
                                      final reactionsCount = ref
                                              .watch(
                                                  messageReactionsCountProvider({
                                                'chatId': widget.chatId,
                                                'messageId': msg.id,
                                              }))
                                              .asData
                                              ?.value ??
                                          0;
                                      return Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              hasReacted
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: hasReacted
                                                  ? KColor.primary
                                                  : Colors.white70,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              _chatService
                                                  .toggleMessageReaction(
                                                widget.chatId,
                                                msg.id,
                                                widget.currentUserId,
                                              );
                                            },
                                          ),
                                          Text(
                                            reactionsCount.toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(msg.senderId)
                                .get(),
                            builder: (context, userSnap) {
                              String initials = '?';
                              if (userSnap.hasData &&
                                  userSnap.data != null &&
                                  userSnap.data!.exists) {
                                final data = userSnap.data!.data()
                                    as Map<String, dynamic>?;
                                if (data != null && data['firstName'] != null) {
                                  initials = data['firstName'][0].toUpperCase();
                                }
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 4, bottom: 2),
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
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 0),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple[300],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            msg.text,
                                            style: const TextStyle(
                                                color: KColor.black),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('h:mm a')
                                              .format(msg.timestamp),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Consumer(
                                    builder: (context, ref, _) {
                                      final hasReacted = ref
                                              .watch(
                                                  hasUserReactedToMessageProvider({
                                                'chatId': widget.chatId,
                                                'messageId': msg.id,
                                                'userId': widget.currentUserId,
                                              }))
                                              .asData
                                              ?.value ??
                                          false;
                                      final reactionsCount = ref
                                              .watch(
                                                  messageReactionsCountProvider({
                                                'chatId': widget.chatId,
                                                'messageId': msg.id,
                                              }))
                                              .asData
                                              ?.value ??
                                          0;
                                      return Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              hasReacted
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: hasReacted
                                                  ? KColor.primary
                                                  : Colors.black54,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              _chatService
                                                  .toggleMessageReaction(
                                                widget.chatId,
                                                msg.id,
                                                widget.currentUserId,
                                              );
                                            },
                                          ),
                                          Text(
                                            reactionsCount.toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'Type a message...'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.deepPurple),
                      onPressed: chatState.sending
                          ? null
                          : () async {
                              final text = _controller.text.trim();
                              if (text.isNotEmpty) {
                                final msg = Message(
                                  id: '',
                                  senderId: widget.currentUserId,
                                  text: text,
                                  timestamp: DateTime.now(),
                                );
                                await ref
                                    .read(chatViewModelProvider.notifier)
                                    .sendMessage(widget.chatId, msg);
                                _controller.clear();
                              }
                            },
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class ChatState {
  final bool sending;
  final String? error;
  ChatState({this.sending = false, this.error});

  ChatState copyWith({bool? sending, String? error}) {
    return ChatState(
      sending: sending ?? this.sending,
      error: error,
    );
  }
}

final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  return ChatViewModel();
});

class ChatViewModel extends StateNotifier<ChatState> {
  ChatViewModel() : super(ChatState());
  final ChatService _chatService = ChatService();

  Future<void> sendMessage(String chatId, Message message) async {
    state = state.copyWith(sending: true, error: null);
    try {
      await _chatService.sendMessage(chatId, message);
      state = state.copyWith(sending: false);
    } catch (e) {
      state = state.copyWith(sending: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final messageReactionsCountProvider =
    StreamProvider.family<int, Map<String, String>>((ref, params) {
  final chatId = params['chatId']!;
  final messageId = params['messageId']!;
  final chatService = ChatService();
  return chatService.getMessageReactionsCount(chatId, messageId);
});

final hasUserReactedToMessageProvider =
    StreamProvider.family<bool, Map<String, String>>((ref, params) {
  final chatId = params['chatId']!;
  final messageId = params['messageId']!;
  final userId = params['userId']!;
  final chatService = ChatService();
  return chatService.hasUserReactedToMessage(chatId, messageId, userId);
});
