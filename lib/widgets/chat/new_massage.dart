import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final recieverId;
  const NewMessage({Key? key, required this.recieverId}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _controller = TextEditingController();

  String _enteredMessage = "";

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userName': userData['userName'],
        'sender': user.uid,
        'userImagePath': userData['userImagePath'],
        'receiver': widget.recieverId
      },
    );
    _controller.clear();
    setState(() {
      _enteredMessage = " ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            autocorrect: true,
            style: TextStyle(color: Theme.of(context).primaryColor),
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                hintText: 'send a message ...',
                hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
            onChanged: (val) {
              setState(() {
                _enteredMessage = val;
              });
            },
          )),
          IconButton(
              disabledColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
