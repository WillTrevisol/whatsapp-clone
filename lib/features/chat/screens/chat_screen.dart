import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/chat-screen';
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  final String name;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(name),
            StreamBuilder(
              stream: ref.read(authControllerProvider).userDataById(uid),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }

                return Text(
                  snapshot.data?.isOnline ? 'online' : 'offline',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                );
              },
            ),
          ],
        ),
        centerTitle: false,
        actions: <Widget> [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: <Widget> [
          Expanded(
            child: ChatList(receiverUserId: uid),
          ),
          BottomChatField(
            receiverUserUid: uid,
          ),
        ],
      ),
    );
  }
}
