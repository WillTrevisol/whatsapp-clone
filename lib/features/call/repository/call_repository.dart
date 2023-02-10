

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/failure.dart';
import '../../../core/firebase_constants.dart';
import '../../../core/typedefs.dart';
import '../../../models/call.dart';

final callRepositoryProvider = Provider(
  (ProviderRef ref) {
    return CallRepository(
      firebaseFirestore: FirebaseFirestore.instance, 
      firebaseAuth: FirebaseAuth.instance,
    );
  },
);

class CallRepository {

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  CallRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  CollectionReference get _call => firebaseFirestore.collection(FirebaseConstants.call);

  FutureVoid makeCall(Call senderCall, Call recieverCall) async {
    try {
      await _call.doc(senderCall.callerUid).set(senderCall.toMap());
      return right(_call.doc(recieverCall.callerUid).set(recieverCall.toMap()));
    } catch (e) {
      log(e.toString());
      return left(Failure('Failure making call.'));
    }
  }

  FutureVoid endCall(
    String callerId,
    String receiverId,
  ) async {
    try {
      await _call.doc(callerId).delete();
      return right(_call.doc(receiverId).delete());
    } catch (e) {
      return left(Failure(':('));
    }
  }

  Stream<DocumentSnapshot> get callStream => _call.doc(firebaseAuth.currentUser!.uid).snapshots();
  
}
