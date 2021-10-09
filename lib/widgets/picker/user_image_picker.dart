import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File? pickedImage) imagePickFn;

  const UserImagePicker(this.imagePickFn, {Key? key}) : super(key: key);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  void _pickImage(ImageSource src) async {
    final XFile? pickImageFile =
        await _picker.pickImage(source: src, imageQuality: 50, maxWidth: 150);
    if (pickImageFile != null) {
      setState(() {
        _pickedImage = File(pickImageFile.path);
      });
      widget.imagePickFn(_pickedImage);
    } else {
      print('No Image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text(
                'Add image \n from camera',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.image_outlined),
              label: const Text(
                'Add image \n from gallery',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ],
    );
  }
}
