import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/widgets/chat/message_bubble.dart';

class Massage extends StatelessWidget {
  final String userId;
  Massage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(
              'chat',
            )
            .where('sender', isEqualTo: user!.uid)
            .where('receiver', isEqualTo: userId)
            .snapshots(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          // ignore: unused_local_variable
          if (snapShot.hasData) {
            final docs = snapShot.data!.docs;

            return ListView.builder(
                reverse: true,
                itemCount: docs.length,
                itemBuilder: (ctx, index) {
                  //print(docs[index]['text']);
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: MessageBubble(
                      text: docs[index]['text'] ?? 'text',
                      userName: docs[index]['userName'] ?? 'user name',
                      userImagePath: docs[index]['userImagePath'],
                      isMe: docs[index]['sender'] == user.uid,
                      key: ValueKey(docs[index].id),
                    ),
                  );
                });
          }
          return const Center(
            child: Text('there is no data found'),
          );
        });
  }
}
