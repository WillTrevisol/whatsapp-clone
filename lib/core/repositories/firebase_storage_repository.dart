import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageRepositoryProvider = Provider(
  (ProviderRef ref) {
    return FirabaseStorageRepository(firebaseStorage: FirebaseStorage.instance);
  }
);

class FirabaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  FirabaseStorageRepository({required this.firebaseStorage});

  Future<String?> storeFileToFirebase(String path, File file) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(path).putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String fileUrl = await taskSnapshot.ref.getDownloadURL();

      return fileUrl;
    } catch (e) {
      rethrow;
    }
  }
}