import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/common/utils/utils.dart';
import '../../../core/constants.dart';
import '../controller/group_controller.dart';
import '../widgets/select_contacts_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = 'create-group-screen';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {

  File? image;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage(BuildContext context) async {
    image = await pickImageFromGalery(context);
    setState(() => image);
  }

  void createGroup() {
    if (nameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider)
        .createGroup(context, nameController.text.trim(), image!,ref.read(selectedGroupContacts));
      ref.read(selectedGroupContacts.notifier).update((state) => []);
      Navigator.pop(context);
    }

    if (nameController.text.trim().isEmpty || image == null) {
      showSnackBar(context: context, message: 'Make sure to add an image, name and contacts', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: <Widget> [
            const SizedBox(height: 10),
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
            Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter group name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
              alignment: Alignment.topLeft,
              child: const Text(
                'Select contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () => createGroup(),
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}