import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/common/utils/utils.dart';
import '../../../models/call.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/call_repository.dart';
import '../screens/call_screen.dart';

final callControllerProvider = Provider(
  (ProviderRef ref) {
    return CallController(
      callRepository: ref.read(callRepositoryProvider), 
      ref: ref,
    );
  },
);

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  CallController({
    required this.callRepository,
    required this.ref,
  });


  void makeCall(BuildContext context, String recieverName, String recieverUid, String recieverPicture, bool isGroupChat) async {
    final user = ref.read(userProvider)!;
    final callId = const Uuid().v1();

    Call senderCallData = Call(
      callerUid: user.uid,
      callerName: user.name,
      callerPicture: user.profilePicture,
      recieverUid: recieverUid,
      recieverName: recieverName,
      recieverPicture: recieverPicture,
      callId: callId,
      hasDialled: true,
    );

    Call recieverCallData = Call(
      callerUid: user.uid, 
      callerName: user.name, 
      callerPicture: user.profilePicture, 
      recieverUid: recieverUid, 
      recieverName: recieverName, 
      recieverPicture: recieverPicture, 
      callId: callId, 
      hasDialled: false,
    );

    final response = await callRepository.makeCall(senderCallData, recieverCallData);

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CallScreen(
            call: senderCallData, 
            channelId: senderCallData.callId, 
            isGroupChat: false,
          )),
        );  
      },
    );
  }

  void endCall(BuildContext context, String callerId, String receiverId) async {
    final response = await callRepository.endCall(callerId, receiverId);

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => Navigator.pop(context),
    );
  }

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
}
