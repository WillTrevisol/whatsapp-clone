import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../colors.dart';

void showSnackBar({required BuildContext context, required String message, bool isError = false}) {

  ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      backgroundColor: isError ? Colors.red : greenColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white
        ),
      ),
    ),
  );

}

Future<File?> pickImageFromGalery(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      return image;
    }

    return image;
  } catch (e) {
    showSnackBar(context: context, message: 'We have a problem :(', isError: true);
    return null;
  }
}