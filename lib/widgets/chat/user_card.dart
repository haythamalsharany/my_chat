import 'package:flutter/material.dart';
import 'package:my_chat/screens/chat_screen.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String imagePath;
  final String userId;
  const UserCard(
      {Key? key,
      required this.userName,
      required this.imagePath,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1),
      elevation: 1.0,
      child: ListTile(

        leading: CircleAvatar(
          backgroundImage: NetworkImage(imagePath),
        ),
        title: Text(userName),
      ),
    );
  }
}
