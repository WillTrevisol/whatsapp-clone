

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/message_enum.dart';
import '../../../core/providers/message_reply_provider.dart';
import '../../../models/message.dart';
import '../../auth/controller/auth_controller.dart';
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

  void onMessageSwipe({
    required String message,
    required bool isMe,
    required MessageEnum messageEnum,
  }) {
    ref.read(messageReplyProvider.notifier).update(
      (state) => MessageReply(
        message: message, 
        isMe: isMe, 
        messageEnum: messageEnum,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).getChatMessages(widget.receiverUserId),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Timer(const Duration(milliseconds: 1000), () => 
            scrollController.animateTo(
              scrollController.position.minScrollExtent, 
              curve: Curves.decelerate, 
              duration: const Duration(seconds: 1),
            ),
          );
        });

        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: snapshot.data?.length,
          reverse: true,
          itemBuilder: (context, index) {

            final Message message = snapshot.data!.reversed.toList()[index];

            if (!message.isSeen && message.receiverUid == ref.read(userProvider)!.uid) {
              ref.read(chatControllerProvider).setSeenMessage(context, widget.receiverUserId, message.messageId);
            }

            if (message.receiverUid == widget.receiverUserId) {
              return MyMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.sentTime),
                type: message.type,
                repliedText: message.repliedMessage,
                userName: message.repliedTo,
                repliedMessageEnum: message.repliedMessageType,
                onLeftSwipe: () => onMessageSwipe(
                  message: message.text, 
                  isMe: true,
                  messageEnum: message.type,
                ),
                isSeen: message.isSeen,
              );
            }
      
            return SenderMessageCard(
              message: message.text,
              date: DateFormat.Hm().format(message.sentTime),
              type: message.type,
                repliedText: message.repliedMessage,
                userName: message.repliedTo,
                repliedMessageEnum: message.repliedMessageType,
                onRightSwipe: () => onMessageSwipe(
                  message: message.text, 
                  isMe: false,
                  messageEnum: message.type,
                ),
            );
          },
        );
      }
    );
  }
}