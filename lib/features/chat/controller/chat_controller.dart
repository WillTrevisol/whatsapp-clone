import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/utils.dart';
import '../../../core/enums/message_enum.dart';
import '../../../models/chat_contact.dart';
import '../../../models/message.dart';
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

  void sendTextMessage(BuildContext context, String text, String recieverUserUid) async {
    final response = await chatRepository.sendTextMessage(
      text: text, 
      receiverUserUid: recieverUserUid, 
      senderUser: ref.read(userProvider)!,
    );

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => null,
    );
  }

  void sendFileMessage(BuildContext context, File file, String recieverUserUid, MessageEnum messageEnum) async {
    final response = await chatRepository.sendFileMessage(
      file: file,
      recieverUserUid: recieverUserUid,
      senderUserData: ref.read(userProvider)!,
      ref: ref,
      messageEnum: messageEnum,
    );

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => null,
    );
  }

  void sendGifMessage(BuildContext context, String gifUrl, String recieverUserUid) async {

    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;

    String gifSlug = gifUrl.substring(gifUrlPartIndex);
    String completeGifString = 'https://i.giphy.com/media/$gifSlug/200.gif';

    final response = await chatRepository.sendGifMessage(
      gifUrl: completeGifString, 
      receiverUserUid: recieverUserUid, 
      senderUser: ref.read(userProvider)!,
    );

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => null,
    );
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.fetchChatContacts();
  }

  Stream<List<Message>> getChatMessages(String receiverUserId) {
    return chatRepository.getChatMessageStream(receiverUserId);
  }

}