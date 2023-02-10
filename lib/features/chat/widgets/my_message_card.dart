import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../core/common/utils/colors.dart';
import '../../../core/enums/message_enum.dart';
import 'display_message.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({super.key, 
  required this.message, 
  required this.date, 
  required this.type, 
  required this.onLeftSwipe, 
  required this.repliedText, 
  required this.userName, 
  required this.repliedMessageEnum,
  required this.isSeen,
});

  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageEnum;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {

    final bool isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: <Widget> [
                Padding(
                  padding: type == MessageEnum.text ? const EdgeInsets.fromLTRB(10, 5, 40, 20)
                  : const EdgeInsets.fromLTRB(5, 5, 5, 20),
                  child: Column(
                    children: <Widget> [
                      if (isReplying) ... [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DisplayMessage(
                            message: repliedText, 
                            type: repliedMessageEnum, 
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                      DisplayMessage(
                        message: message, 
                        type: type, 
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 5,
                  child: Row(
                    children: <Widget> [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 16,
                        color: isSeen ? Colors.blue : Colors.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}