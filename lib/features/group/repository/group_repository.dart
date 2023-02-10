import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../core/failure.dart';
import '../../../core/firebase_constants.dart';
import '../../../core/repositories/firebase_storage_repository.dart';
import '../../../core/typedefs.dart';
import '../../../models/user.dart';
import '../../../models/group.dart' as model;
import '../../auth/controller/auth_controller.dart';

final groupRepositoryProvider = Provider(
  (ProviderRef ref) {
    return GroupRepository(
      firebaseFirestore: FirebaseFirestore.instance, 
      firebaseAuth: FirebaseAuth.instance, 
      ref: ref,
    );
  },
);

class GroupRepository {

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  GroupRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.ref,
  });

  CollectionReference get _users => firebaseFirestore.collection(FirebaseConstants.users);
  CollectionReference get _groups => firebaseFirestore.collection(FirebaseConstants.groups);

  FutureVoid createGroup(String groupName, File file, List<Contact> contacts) async {
    try {
      List<String>? usersUid = [];
      final users = await _users.get();

      for (var data in users.docs) {
        for (var contact in contacts) {
          final userData = UserModel.fromMap(data.data() as Map<String, dynamic>);
          if (contact.phones.isNotEmpty) {
            final normalizedNumber = contact.phones[0].number.replaceAll(' ', '');
            if (userData.phoneNumber.contains(normalizedNumber)) {
              usersUid.add(userData.uid);
            }
          }
        }
      }

      final groupId = const Uuid().v1();

      final fileUrl = await ref.read(firebaseStorageRepositoryProvider)
        .storeFileToFirebase('group/$groupId', file);

      model.Group group = model.Group(
        name: groupName, 
        groupId: groupId, 
        lastMessage: 'This group was created by ${ref.read(userProvider)!.name}', 
        lastSenderUid: ref.read(userProvider)!.uid,
        groupProfilePicture: fileUrl??'',
        membersUid: [ref.read(userProvider)!.uid, ...usersUid],
        sentTime: DateTime.now(),
      );

      return right(_groups.doc(groupId).set(group.toMap()));

    } catch (e) {
      return left(Failure('Error creating group'));
    }
  }
}
