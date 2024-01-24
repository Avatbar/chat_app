import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final enteredMessage = _controller.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _controller.clear();

    final userUid = FirebaseAuth.instance.currentUser!.uid;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get();

    // Add message to firebase
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': userUid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
