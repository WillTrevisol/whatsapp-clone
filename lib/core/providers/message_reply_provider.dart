import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/message_enum.dart';

final messageReplyProvider = StateProvider<MessageReply?>(
  (StateProviderRef ref) => null,
);

class MessageReply {

  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageEnum,
  });

}
