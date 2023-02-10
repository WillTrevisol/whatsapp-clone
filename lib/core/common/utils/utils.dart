import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';

import 'colors.dart';

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

Future<File?> pickImageFromCamera(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

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

Future<File?> pickVideoFromGalery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
      return video;
    }

    return video;
  } catch (e) {
    showSnackBar(context: context, message: 'We have a problem :(', isError: true);
    return null;
  }
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  //KfUhh9mv2rvNHtD5saxYyem86PTNtsFs
  GiphyGif? gif;
  try {
    gif = await GiphyGet.getGif(
      context: context, 
      apiKey: 'KfUhh9mv2rvNHtD5saxYyem86PTNtsFs',
      lang: GiphyLanguage.portuguese,
    );
  } catch (e) {
    showSnackBar(context: context, message: 'We have a problem :(', isError: true);
  }

  return gif;
}