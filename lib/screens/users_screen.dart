import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/widgets/chat/user_card.dart';

import 'chat_screen.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' chat'),
        actions: [
          DropdownButton(
            underline: Container(),
            onChanged: (dropdownMenuItemValue) {
              if (dropdownMenuItemValue == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('userId', isNotEqualTo: user!.uid)
                .snapshots(),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              // ignore: unused_local_variable
              if (snapShot.hasData) {
                final docs = snapShot.requireData.docs;
                print(
                    '-------------------------------------${docs.length}--------------------------');

                return ListView.builder(
                    //reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (ctx, index) {
                      //print(docs[index]['text']);
                      return InkWell(
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return ChatScreen(
                            userId: docs[index]['userId'],
                          );
                        })),
                        child: UserCard(
                          userName: docs[index]['userName'],
                          imagePath: docs[index]['userImagePath'],
                          userId: docs[index]['userId'],
                        ),
                      );
                    });
              }
              return const Center(
                child: Text('there is no data found'),
              );
            }),
      ),
    );
  }
}
