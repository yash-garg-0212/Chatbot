import 'package:flutter/material.dart';
import 'package:chatbot/services/gemini_service_api.dart';
import 'package:chatbot/screen/login_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  GeminiService geminiService = GeminiService();

  void sendMessage() async {
    String userMessage = _controller.text;
    setState(() {
      messages.add("You: $userMessage");
    });

    _controller.clear();

    try {
      String botResponse = await geminiService.getResponse(userMessage); // Use the service
      setState(() {
        messages.add("Bot: $botResponse");
      });
    } catch (e) {
      setState(() {
        messages.add("Bot: Sorry, something went wrong.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ChatScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            child: Text(
              'New chat',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => LoginScreen()));
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      label: Text('Ask anything'),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: Icon(
                    Icons.send_rounded,
                    size: 40,
                  ),
                )
              ],
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
