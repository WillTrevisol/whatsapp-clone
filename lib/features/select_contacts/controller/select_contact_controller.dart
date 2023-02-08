import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/utils.dart';
import '../../chat/screens/chat_screen.dart';
import '../repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider(
  (FutureProviderRef ref) {
    final selectContactRepository = ref.watch(selectContactRepositoryProvider);
    return selectContactRepository.getContacts();
  },
);

final selectContactControllerProvider = Provider(
  (ProviderRef ref) {
    final selectContactRepository = ref.watch(selectContactRepositoryProvider);
    return SelectContactController(
      ref: ref, 
      selectContactRepository: selectContactRepository,
    );
  } 
);

class SelectContactController {

  final Ref ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({required this.ref, required this.selectContactRepository});

  void selectContact(BuildContext context, Contact contact) async {
    final response = await selectContactRepository.selectContact(contact);

    response.fold(
      (left) => showSnackBar(context: context, message: left.message), 
      (right) {
        if (right['isFound']) {
          Navigator.of(context).pushReplacementNamed(MobileChatScreen.routeName, arguments: {
            'name': right['user']['name'],
            'uid': right['user']['uid'],
          });
          return;
        }
        if (!right) {
          showSnackBar(context: context, message: 'User not found.\nInvite him to this app! :)');
          return;
        }
      }
    );
  }

}