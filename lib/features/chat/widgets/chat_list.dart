

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/message.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';
import '../controller/chat_controller.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key, required this.receiverUserId});

  final String receiverUserId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).getChatMessages(widget.receiverUserId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: scrollController,
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {

            final message = snapshot.data![index];
            if (message.receiverUid == widget.receiverUserId) {
              return MyMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.sentTime),
              );
            }
      
            return SenderMessageCard(
              message: message.text,
              date: DateFormat.Hm().format(message.sentTime),
            );
          },
        );
      }
    );
  }
}