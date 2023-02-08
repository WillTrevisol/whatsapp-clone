import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/failure.dart';
import '../../../core/firebase_constants.dart';
import '../../../core/typedefs.dart';
import '../../../models/user.dart';

final selectContactRepositoryProvider = Provider(
  (ProviderRef ref) {
    return SelectContactRepository(firebaseFirestore: FirebaseFirestore.instance);
  }
);

class SelectContactRepository {
  final FirebaseFirestore firebaseFirestore;

  SelectContactRepository({required this.firebaseFirestore});

  CollectionReference get _users => firebaseFirestore.collection(FirebaseConstants.users);

  Future<List<Contact?>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      return contacts;
    } catch (e) {
      log(e.toString());
    }

    return contacts;
  }

  FutureEither selectContact(Contact contact) async {
    try {
      final users = await _users.get();
      bool isFound = false;
      UserModel? user;

      for (var data in users.docs) {
        final userData = UserModel.fromMap(data.data() as Map<String, dynamic>);
        
        final normalizedNumber = contact.phones[0].number.replaceAll(' ', '');

        if (userData.phoneNumber.contains(normalizedNumber)) {
          user = userData;
          isFound = true;
        }
      }

      return right({
        'isFound' : isFound,
        'user': user?.toMap(),
      });

    } catch (e) {
      log(e.toString());
      return left(Failure('We have a problem :('));
    }
  }
}