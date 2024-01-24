import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('An error occurred'),
          );
        }

        final chatDocs = chatSnapshot.data!.docs;

        return ListView.builder(
            padding:
                const EdgeInsets.only(bottom: 40, top: 10, left: 10, right: 10),
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) {
              final chatMessages = chatDocs[index].data();
              final nextChatMessages = index + 1 < chatDocs.length
                  ? chatDocs[index + 1].data()
                  : null;
              final currentMessageUserUid = chatMessages['userId'];
              final nextMessageUserUid =
                  nextChatMessages != null ? nextChatMessages['userId'] : null;
              final nextUserIsSame = currentMessageUserUid == nextMessageUserUid;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessages['text'],
                  isMe: authUser.uid == currentMessageUserUid,
                );
              } else {
                return MessageBubble.first(
                  userImage: chatMessages['userImage'],
                  username: chatMessages['username'],
                  message: chatMessages['text'],
                  isMe: authUser.uid == currentMessageUserUid,
                );
              }

            });
      },
    );
  }
}
