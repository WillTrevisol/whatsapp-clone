import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/colors.dart';
import '../../../core/providers/message_reply_provider.dart';
import 'display_message.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update(
      (state) => null,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: mobileChatBoxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget> [
          Row(
            children: <Widget> [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'You' : 'Person',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => cancelReply(ref),
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: backgroundColor,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top:8.0, bottom:8.0),
                child: DisplayMessage(
                  message: messageReply.message, 
                  type: messageReply.messageEnum,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}