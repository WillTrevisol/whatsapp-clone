import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../core/enums/message_enum.dart';
import 'display_message.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({super.key, required this.message, required this.date, required this.type});

  final String message;
  final String date;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return Align(
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
                padding: type == MessageEnum.text ? const EdgeInsets.fromLTRB(10, 5, 45, 20)
                : const EdgeInsets.fromLTRB(5, 5, 5, 20),
                child: DisplayMessage(
                  message: message, 
                  type: type, 
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
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
                    const Icon(
                      Icons.done_all,
                      size: 16,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}