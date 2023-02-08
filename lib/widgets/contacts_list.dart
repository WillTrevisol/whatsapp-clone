import 'package:flutter/material.dart';

import '../info.dart';
import '../features/chat/screens/chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: info.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileChatScreen(name: 'fds', uid: 'fdsaf',))),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(info[index]['profilePic'].toString()),
                radius: 25,
              ),
              title: Text(
                info[index]['name'].toString(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  info[index]['message'].toString(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              trailing: Text(
                info[index]['time'].toString(),
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
}