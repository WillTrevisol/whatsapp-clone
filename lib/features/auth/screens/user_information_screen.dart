import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/colors.dart';
import '../../../core/common/utils/utils.dart';
import '../../../core/constants.dart';
import '../controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/userInformationScreen';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {

  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage(BuildContext context) async {
    image = await pickImageFromGalery(context);
    setState(() => image);
  }

  void storeUserData() {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, image);
      return;
    }

    showSnackBar(context: context, message: 'Type your name', isError: true);
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              const SizedBox(height: 80),
              Stack(
                children: <Widget> [
                  image == null ? const CircleAvatar(
                    backgroundColor: backgroundColor,
                    backgroundImage: AssetImage(Constants.noProfileAsset),
                    radius: 80,
                  ) : 
                  CircleAvatar(
                    backgroundColor: backgroundColor,
                    backgroundImage: FileImage(image!),
                    radius: 80,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => selectImage(context), 
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget> [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData, 
                    icon: const Icon(Icons.done),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}