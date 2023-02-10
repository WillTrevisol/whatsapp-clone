import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../core/failure.dart';
import '../../../core/firebase_constants.dart';
import '../../../core/repositories/firebase_storage_repository.dart';
import '../../../core/typedefs.dart';
import '../../../models/status.dart';
import '../../../models/user.dart';

final statusRepositoryProvider = Provider(
  (ProviderRef ref) {
    return StatusRepository(
      firebaseFirestore: FirebaseFirestore.instance, 
      firebaseAuth: FirebaseAuth.instance, 
      ref: ref,
    );
  },
);

class StatusRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  StatusRepository({
    required this.firebaseFirestore, 
    required this.firebaseAuth, 
    required this.ref,
  });

  CollectionReference get _users => firebaseFirestore.collection(FirebaseConstants.users);
  CollectionReference get _status => firebaseFirestore.collection(FirebaseConstants.status);

  FutureVoid uploadStatus({
    required String userName,
    required String profilePicture,
    required String phoneNumber,
    required File statusImage,
  }) async {
    try {

      final statusId = const Uuid().v1();
      String uid = firebaseAuth.currentUser!.uid;

      final imageUrl = await ref.read(firebaseStorageRepositoryProvider)
        .storeFileToFirebase('status/$statusId$uid', statusImage);

      final users = await _users.get();
      List<Contact> contacts = [];
      List<String> whoCanSee = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (var data in users.docs) {
        for (var contact in contacts) {
          final userData = UserModel.fromMap(data.data() as Map<String, dynamic>);
          if (contact.phones.isNotEmpty) {
            final normalizedNumber = contact.phones[0].number.replaceAll(' ', '');
            if (userData.phoneNumber.contains(normalizedNumber)) {
              whoCanSee.add(userData.uid);
            }
          }
        }
      }

      List<String> statusImagesUrl = [];
      final statusSnapshot = await _status
        .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();

      if (statusSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusSnapshot.docs.first.data() as Map<String, dynamic>);
        statusImagesUrl = status.photoUrl;
        statusImagesUrl.add(imageUrl??'');
        return right(
          _status.doc(statusSnapshot.docs[0].id).update({
            'photoUrl' : statusImagesUrl,
          }),
        ); 
      }

      if (statusSnapshot.docs.isEmpty) {
        statusImagesUrl = [imageUrl??''];
      }

      Status status = Status(
        uid: uid, 
        statusId: statusId, 
        userName: userName, 
        phoneNumber: phoneNumber, 
        profilePicture: profilePicture, 
        photoUrl: statusImagesUrl, 
        whoCanSee: whoCanSee, 
        createdAt: DateTime.now(),
      );

      return right(
        _status.doc(statusId).set(status.toMap()),
      );

    } catch (e) {
      log(e.toString());
      return left(Failure('Error when uploading status image.'));
    }
  }

  FutureEither getStatus() async {
    List<Status> status = [];
    try {
      final users = await _users.get();
      List<Contact> contacts = [];
      List<String> whoCanSee = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (var data in users.docs) {
        for (var contact in contacts) {
          final userData = UserModel.fromMap(data.data() as Map<String, dynamic>);
          if (contact.phones.isNotEmpty) {
            final normalizedNumber = contact.phones[0].number.replaceAll(' ', '');
            if (userData.phoneNumber.contains(normalizedNumber)) {
              whoCanSee.add(userData.uid);
            }
          }
        }
      }

      for (var uid in whoCanSee) {
        await _status
          .where('whoCanSee', arrayContains: uid)
          .where(
            'createdAt', 
            isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch)
          .get().then((value) {
            for (var doc in value.docs) {
              status.add(Status.fromMap(doc.data() as Map<String, dynamic>));
            }
          });
      }
    } catch (e) {
      log(e.toString());
      return left(Failure('Error when geting status images'));
    }

    return right(status);
  }


}