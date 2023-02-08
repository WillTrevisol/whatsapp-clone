import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';

import '../../../core/enums/message_enum.dart';
import '../../../core/failure.dart';
import '../../../core/firebase_constants.dart';
import '../../../core/typedefs.dart';
import '../../../models/message.dart';
import '../../../models/user.dart';

final chatRepositoryProvider = Provider(
  (ProviderRef ref) => ChatRepository(
    firebaseFirestore: FirebaseFirestore.instance, 
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class ChatRepository {

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  CollectionReference get _users => firebaseFirestore.collection(FirebaseConstants.users);

  void _saveDataToContactsSubCollection(
    UserModel senderUser,
    UserModel receiverUser,
    String text,
    DateTime sentTime,
  ) async {

    final receiverChatContact = ChatContact(
      name: senderUser.name, 
      profilePicture: senderUser.profilePicture, 
      contactUid: senderUser.uid, 
      timeSent: sentTime, 
      lastMessage: text,
    );

    await _users.doc(receiverUser.uid)
      .collection(FirebaseConstants.chats)
      .doc(firebaseAuth.currentUser!.uid)
      .set(receiverChatContact.toMap());

    final senderChatContact = ChatContact(
      name: receiverUser.name, 
      profilePicture: receiverUser.profilePicture, 
      contactUid: receiverUser.uid, 
      timeSent: sentTime, 
      lastMessage: text,
    );

    await _users.doc(firebaseAuth.currentUser!.uid)
      .collection(FirebaseConstants.chats)
      .doc(receiverUser.uid)
      .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageColletion({
    required String receiverUserUid,
    required String text,
    required DateTime sentTime,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    final Message message = Message(
      senderUid: firebaseAuth.currentUser!.uid, 
      receiverUid: receiverUserUid,
      text: text, 
      type: messageType, 
      sentTime: sentTime, 
      messageId: messageId, 
      isSeen: false,
    );

    await _users.doc(firebaseAuth.currentUser!.uid)
      .collection(FirebaseConstants.chats).doc(receiverUserUid)
      .collection(FirebaseConstants.messages).doc(messageId)
      .set(message.toMap());

    await _users.doc(receiverUserUid)
      .collection(FirebaseConstants.chats).doc(firebaseAuth.currentUser!.uid)
      .collection(FirebaseConstants.messages).doc(messageId)
      .set(message.toMap());

  }

  FutureVoid sendTextMessage({
    required String text,
    required String receiverUserUid,
    required UserModel senderUser,
  }) async {

    try {
      final sentTime = DateTime.now();
      UserModel receiverUserData;

      final receiverData = await _users.doc(receiverUserUid).get();
      receiverUserData = UserModel.fromMap(receiverData.data() as Map<String, dynamic>);
      final messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(senderUser, receiverUserData, text, sentTime);
      return right(_saveMessageToMessageColletion(
        receiverUserUid: receiverUserUid, 
        text: text, 
        sentTime: sentTime, 
        messageId: messageId,
        userName: senderUser.name, 
        receiverUserName: receiverUserData.name, 
        messageType: MessageEnum.text,
      ));

    } catch (e) {
      log(e.toString());
      return left(Failure('Ops'));
    }

  }

}