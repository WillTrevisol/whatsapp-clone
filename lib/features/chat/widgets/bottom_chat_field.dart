import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    super.key,
    required this.receiverUserUid,
  });

  final String receiverUserUid;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {

  final TextEditingController _messageController = TextEditingController();
  bool showSendButton = false;

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void sendTextMessage() async {
    if (showSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(context, _messageController.text.trim(), widget.receiverUserUid);
      setState(() {
        _messageController.text = '';
        showSendButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: <Widget> [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: SizedBox(
                width: size.width * 0.1,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: size.width * 0.10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const <Widget> [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
              hintText: 'Message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(()=> showSendButton = true);
              }
              if (value.isEmpty) {
                setState(()=> showSendButton = false);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: GestureDetector(
            onTap: () => sendTextMessage(),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              radius: 22,
              child: Icon(
                showSendButton ? Icons.send : Icons.mic_rounded,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}