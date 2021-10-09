import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_chat/widgets/picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String userName,
      File? image, bool isLogin, BuildContext ctx) submitFun;
  final bool isLoading;
  const AuthForm(
    this.submitFun,
    this.isLoading, {
    Key? key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _userName = '';
  bool _isLogin = true;
  File? _userImageFile;
  void _pickedImage(File? imageFile) {
    setState(() {
      _userImageFile = imageFile;
    });
  }

  _submit() {
    var isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFun(
          _email, _password, _userName, _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return ' please enter valid email address';
                    }
                    return null;
                  },
                  onSaved: (val) => _email = val!,
                ),
                if (!_isLogin)
                  TextFormField(
                    autocorrect: true,
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.words,
                    key: const ValueKey('userName'),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(labelText: 'User Name'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return 'User name must be more than 4 charecter';
                      }
                      return null;
                    },
                    onSaved: (val) => _userName = val!,
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'password'),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'password must be more than 8 charecter';
                    }
                    return null;
                  },
                  onSaved: (val) => _password = val!,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? 'Login' : 'SignUp')),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () => setState(() {
                      _isLogin = !_isLogin;
                    }),
                    child: Text(_isLogin
                        ? 'create  new account'
                        : 'Already have account'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
