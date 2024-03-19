import 'package:app_news/apps/helper/show_toast.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

import '../../apps/const/key.dart';
import '../../manage/store/user_store.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final OpenAI _openAI = OpenAI.instance.build(
    token: MyKey.OPENAI_API_KEY,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Customer', lastName: 'Yikes');
  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'Bot');
  final List<ChatMessage> _messages = <ChatMessage>[];

  final List<ChatUser> _typingUsers = <ChatUser>[];

  Stream<int> getUserCoinsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['coins'] ?? 0);
  }

  final String userId = UserStore.to.userInfo.id!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chat bot",
                      style: Theme.of(context).textTheme.labelLarge),
                  Text("Trợ lí ảo của LH2K",
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            StreamBuilder<int>(
              stream: getUserCoinsStream(userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Số Coins: ${snapshot.data}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Nhập bất kì câu hỏi bạn muốn hỏi.",
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Center(
            child: _messages.isEmpty
                ? Text("Chưa có tin nhắn nào !",
                    style: Theme.of(context).textTheme.bodySmall)
                : null,
          ),
          Expanded(
            child: DashChat(
              currentUser: _currentUser,
              typingUsers: _typingUsers,
              messageOptions: MessageOptions(
                currentUserContainerColor: Colors.black,
                containerColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
              onSend: (ChatMessage m) {
                getChatResponse(m);
              },
              messages: _messages,
              inputOptions: const InputOptions(
                inputTextStyle: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    final String userId = UserStore.to.userInfo.id!;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData =
        userDoc.data() as Map<String, dynamic>? ?? {};
    int currentCoins = userData['coins'] ?? 0;

    if (currentCoins <= 0) {
      showToastError("Bạn không có đủ coin để chat.");
      return;
    }

    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    List<Messages> messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: messagesHistory,
      maxToken: 1000,
    );

    final response = await _openAI.onChatCompletion(request: request);

    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: element.message!.content),
          );
        });
      }
    }

    setState(() {
      _typingUsers.remove(_gptChatUser);
    });

    // Trừ 1 coin sau khi nhận phản hồi từ OpenAI
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'coins': FieldValue.increment(-1)});
  }
}
