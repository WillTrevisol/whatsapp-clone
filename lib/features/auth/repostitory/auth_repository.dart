import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants.dart';
import '../../../core/failure.dart';
import '../../../core/firebase_constants.dart';
import '../../../core/repositories/firebase_storage_repository.dart';
import '../../../core/typedefs.dart';
import '../../../models/user.dart';
import '../screens/otp_screen.dart';

final authRepositoryProvider = Provider(
  (ProviderRef ref) => AuthRepository(
    firebaseAuth: FirebaseAuth.instance, 
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  CollectionReference get _users => firebaseFirestore.collection(FirebaseConstants.users);

  FutureEither getCurrentUserData() async {
    try {
      final userData = await _users.doc(firebaseAuth.currentUser?.uid).get();
      UserModel? user;

      if (userData.data() != null) {
        user = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      }

      return right(user);
    } catch (e) {
      log(e.toString());
      return left(Failure('Error getting current user'));
    }
  }

  FutureVoid signInWithPhone({required BuildContext context, required String phoneNumber}) async {
    try {
      return right(
        firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber, 
          verificationCompleted: (PhoneAuthCredential credential) async {
            await firebaseAuth.signInWithCredential(credential);
          }, 
          codeSent: (String verificationId, int? forceResendingToken) async {
            Navigator.of(context).pushNamed(OTPScreen.routeName, arguments: verificationId);
          }, 
          codeAutoRetrievalTimeout: (String verificationId) {

          }, 
          verificationFailed: (FirebaseAuthException error) => throw Exception(error.message),
        ),
      );
    } catch (e) {
      log(e.toString());
      return left(Failure('Failed to send number :('));
    }
  }

  FutureEither verifyOTP({required BuildContext context, required String verificationId, required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, 
        smsCode: userOTP,
      );

      return right(firebaseAuth.signInWithCredential(credential));
    } catch (e) {
      log(e.toString());
      return left(Failure('Failed to verify.'));
    }
  }

  FutureVoid saveUserDataToFirebase({
    required BuildContext context, 
    required String name, 
    required File? profilePicture, 
    required Ref ref,
  }) async {

    try {
      String uid = firebaseAuth.currentUser!.uid;
      String photoUrl = File(Constants.noProfileAsset).path;

      if (profilePicture != null) {
        photoUrl = await ref.read(firebaseStorageRepositoryProvider)
          .storeFileToFirebase('profilePicture/$uid', profilePicture) as String;
      }

      UserModel user = UserModel(
        name: name,
        uid: uid,
        profilePicture: photoUrl,
        isOnline: true,
        phoneNumber: firebaseAuth.currentUser!.phoneNumber ?? uid,
        groupsId: [],
      );
      return right(_users.doc(uid).set(user.toMap()));

    } catch (e) {
      log(e.toString());
      return left(Failure('We have a problem saving your data :('));
    }
  }

  Stream<UserModel> userData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
  
}