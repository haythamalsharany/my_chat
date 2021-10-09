import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(String email, String password, String userName,
      File? image, bool isLogin, BuildContext ctx) async {
    late UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        var ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredential.user!.uid}.jpg');
        await ref.putFile(image!);
        var imageUrl = await ref.getDownloadURL();
        print('________________________imageUrl:${imageUrl}');
        var firebaseUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'userName': userName,
          'password': password,
          'userImagePath': imageUrl,
          'userId': userCredential.user!.uid
        });
        // print('________________________fireStorUser:${fireStorUser}');
      }
    } on FirebaseAuthException catch (e) {
      String massage = '';
      if (e.code == 'weak-password') {
        massage = 'The Password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        massage = 'The account is already exist for that email';
      } else if (e.code == 'user-not-found') {
        massage = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        massage = 'Wrong password provided for that user ';
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(massage),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
