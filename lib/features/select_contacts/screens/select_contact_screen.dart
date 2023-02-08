import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/error_screen.dart';
import '../../../core/common/widgets/loading_widget.dart';
import '../controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactScreen({super.key});

  

  void selectContact(BuildContext context, WidgetRef ref, Contact contact) {
    ref.read(selectContactControllerProvider).selectContact(context, contact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {

            if (data.isEmpty) {
              return const Center(
                child: Text('Empty contact list...'),
              );
            }
            
            final contact = data[index];
            return GestureDetector(
              onTap: () => selectContact(context, ref, contact!),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: contact?.photo == null ? null : CircleAvatar(
                    backgroundImage: MemoryImage(contact!.photo!),
                  ),
                  title: Text(
                    contact?.displayName ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
          },
        ), 
        error: (error, stackTrace) => ErrorScreen(message: error.toString()), 
        loading: () => const LoadingWidget(),
      ),
    );
  }
}