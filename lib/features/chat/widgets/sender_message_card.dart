// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../colors.dart';
import '../../../core/enums/message_enum.dart';
import 'display_message.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageEnum,
  }) : super(key: key);

  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageEnum;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: <Widget> [
                Padding(
                  padding: type == MessageEnum.text ? const EdgeInsets.fromLTRB(15, 5, 20, 20)
                  : const EdgeInsets.fromLTRB(5, 5, 5, 20),
                  child: DisplayMessage(
                    message: message, 
                    type: type, 
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
