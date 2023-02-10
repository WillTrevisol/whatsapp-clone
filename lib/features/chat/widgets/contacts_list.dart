import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/loading_widget.dart';
import '../../../models/group.dart';
import '../controller/chat_controller.dart';
import '../screens/chat_screen.dart';
import '../../../models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget> [
          StreamBuilder<List<Group>>(
            stream: ref.watch(chatControllerProvider).getChatGroups(),
            builder: (context, snapshot) {
    
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
    
              if (snapshot.data!.isEmpty) {
                return Container();
              }
    
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  final chatGroup = snapshot.data![index];
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      MobileChatScreen.routeName,
                      arguments: {
                        'name': chatGroup.name,
                        'uid': chatGroup.groupId,
                        'isGroupChat': true,
                      }
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(chatGroup.groupProfilePicture),
                          radius: 25,
                        ),
                        title: Text(
                          chatGroup.name,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            chatGroup.lastMessage,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatGroup.sentTime),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } 
          ),
          StreamBuilder<List<ChatContact>>(
            stream: ref.watch(chatControllerProvider).getChatContacts(),
            builder: (context, snapshot) {
    
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
    
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Start chating!'
                  ),
                );
              }
    
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  final chatContact = snapshot.data![index];
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      MobileChatScreen.routeName,
                      arguments: {
                        'name': chatContact.name,
                        'uid': chatContact.contactUid,
                        'isGroupChat': false,
                      }
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(chatContact.profilePicture),
                          radius: 25,
                        ),
                        title: Text(
                          chatContact.name,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            chatContact.lastMessage,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatContact.timeSent),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } 
          ),
        ],
      ),
    );
  }
}