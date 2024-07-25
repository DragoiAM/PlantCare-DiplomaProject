import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Tools/consts.dart';

import 'Components/nav_bar.dart';
import 'home_page.dart';

class ChatPage extends StatefulWidget {
  final String userID;
  const ChatPage({
    required this.userID,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int? _selectedIndex = 1;
  final String userId = '';
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  userId: widget.userID,
                )),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  userID: widget.userID,
                )),
      );
    }
  }

  final _openAi = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      ),
    ),
    enableLog: true,
  );
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'User', lastName: 'User');
  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Asistentul', lastName: 'tau');
  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight * 1,
        color: Theme.of(context).colorScheme.background,
        child: DashChat(
          currentUser: _currentUser,
          typingUsers: _typingUsers,
          inputOptions: InputOptions(
            inputTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            inputDecoration: InputDecoration(
              hintText: "Scrie intrebarea ta aici...",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            sendButtonBuilder: (Function send) {
              return IconButton(
                icon: const Icon(Icons.send),
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Set the color of the send icon to black
                onPressed: () => send(),
              );
            },
          ),
          messageOptions: MessageOptions(
            currentUserContainerColor: Theme.of(context).colorScheme.surface,
            currentUserTextColor: Theme.of(context).colorScheme.onSurface,
            containerColor: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages,
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    // Custom prompt that directs the AI to focus on plant-related questions in Romanian
    String customPrompt =
        "Vă rog să răspundeți doar la întrebări despre plante. "
        "Dacă întrebarea nu este despre plante, formuleaza un mesaj de respingere cat mai politicos.";

    List<Map<String, dynamic>> messagesHistory = _messages.reversed.map((m) {
      return {
        "role": m.user == _currentUser ? "user" : "assistant",
        "content":
            "$customPrompt\n${m.text}", // Prepend the custom prompt to each message
      };
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: messagesHistory, // Pass the converted list
      maxToken: 200,
    );

    final response = await _openAi.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
              0,
              ChatMessage(
                  user: _gptChatUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content));
        });
      }
    }

    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}
