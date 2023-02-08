import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/chat_repository.dart';

final chatControllerProvider = Provider(
  (ProviderRef ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(
      chatRepository: chatRepository, 
      ref: ref,
    );
  } 
);

class ChatController {

  final ChatRepository chatRepository;
  final Ref ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(BuildContext context, String text, String receiverUserUid) async {
    final response = await chatRepository.sendTextMessage(
      text: text, 
      receiverUserUid: receiverUserUid, 
      senderUser: ref.read(userProvider)!,
    );

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => null,
    );
  }

}