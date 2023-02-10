import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/colors.dart';
import '../../auth/controller/auth_controller.dart';
import '../../call/controller/call_controller.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/chat-screen';
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePicture,
  }) : super(key: key);

  final String name;
  final String uid;
  final String profilePicture;
  final bool isGroupChat;

  void makeCall(BuildContext context, WidgetRef ref) {
    ref.read(callControllerProvider)
      .makeCall(context, name, uid, profilePicture, isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(name),
            if (!isGroupChat)
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
          !isGroupChat ?
          IconButton(
            onPressed: () => makeCall(context, ref),
            icon: const Icon(Icons.call),
          ) : Container(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundImage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget> [
            Expanded(
              child: ChatList(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              recieverUserUid: uid,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}
