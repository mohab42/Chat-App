// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, unnecessary_null_comparison
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  void Function(File file) imagePickerFn;
  UserImagePicker({
    Key? key,
    required this.imagePickerFn,
  }) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  File? pickedImage;

  void pickImage(ImageSource source) async {
    final pickedImageFile =
        await picker.pickImage(source: source, imageQuality: 50, maxWidth: 150);
    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickerFn(pickedImage!);
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () => pickImage(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text(
                'Add Image\n from Camera',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
            TextButton.icon(
              onPressed: () => pickImage(ImageSource.gallery),
              icon: const Icon(Icons.image_outlined),
              label: const Text(
                'Add Image\n from Gallery',
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )
      ],
    );
  }
}
