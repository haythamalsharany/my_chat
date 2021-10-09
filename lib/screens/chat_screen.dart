import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/widgets/chat/massage.dart';
import 'package:my_chat/widgets/chat/new_massage.dart';

class ChatScreen extends StatelessWidget {
  final String userId;
  ChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter chat'),
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
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Massage(
              userId: userId,
            )),
            NewMessage(
              recieverId: userId,
            )
          ],
        ),
      ),
    );
  }
}
