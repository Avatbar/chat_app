import 'package:chat_app/widgets/chat_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void _setUpNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    fcm.subscribeToTopic('chat');

  }

  @override
  void initState() {
    super.initState();
    _setUpNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatApp'),
        actions: [
          IconButton(
              onPressed: () {
                // Log user out
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              )),
        ],
      ),
      body: Center(
        child: Column(
          children: const [
            Expanded(
              child: ChatMessages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
