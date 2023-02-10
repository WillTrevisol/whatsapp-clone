import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../core/common/widgets/error_screen.dart';
import '../../../core/common/widgets/loading_widget.dart';
import '../../select_contacts/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>(
  (StateProviderRef ref) => [],
);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {

  List<int> selectContactIndex = [];

  void selectContact(int index, Contact contact) {
    setState(() => selectContactIndex.add(index));
    ref.read(selectedGroupContacts.notifier).update(
      (state) => [...state, contact]);
  }

  void removeContact(int index, Contact contact) {
    setState(() => selectContactIndex.remove(index));
    ref.read(selectedGroupContacts.notifier).update(
      (state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
      data: (data) {
        return Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final contact = data[index];

              return ListTile(
                trailing: selectContactIndex.contains(index) ?
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check_circle_rounded,
                    color: greenColor,
                  ),
                ) : null,
                title: Text(
                  contact?.displayName ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () => selectContactIndex.contains(index) ? 
                   removeContact(index, contact!) : 
                   selectContact(index, contact!),
              );
            },
          ),
        );
      }, 
      error: (error, stackTrace) => ErrorScreen(message: error.toString()), 
      loading: () => const LoadingWidget(),
    );
  }
}