import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String userName;
  final bool isMe;
  final String userImagePath;
  @override
  final Key? key;

  const MessageBubble(
      {required this.text,
      required this.userName,
      required this.userImagePath,
      required this.isMe,
      this.key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color:
                      isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(14),
                    topLeft: const Radius.circular(14),
                    bottomLeft: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(14),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(14),
                  )),
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(userName),
                  Text(
                    text,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: 2,
            left: !isMe ? 120 : null,
            right: isMe ? 120 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImagePath),
            ))
      ],
      clipBehavior: Clip.none,
    );
  }
}
