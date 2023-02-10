import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/utils.dart';
import '../../../models/user.dart';
import '../../../mobile_screen_layout.dart';
import '../repostitory/auth_repository.dart';
import '../screens/user_information_screen.dart';

final userProvider = StateProvider<UserModel?>((StateProviderRef ref) => null);

final userDataProvider = FutureProvider(
  (FutureProviderRef ref) {
    final authController = ref.watch(authControllerProvider);
    return authController.getCurrentUserData();
  },
);

final authControllerProvider = Provider(
  (ProviderRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(
      authRepository: authRepository,
      ref: ref,
    );
  },
);

class AuthController {

  final AuthRepository authRepository;
  final Ref ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user;
    final response = await authRepository.getCurrentUserData();

    response.fold(
      (left) => null, 
      (right) => user = right,
       //ref.read(userProvider.notifier).update((state) => right),
    );

    return user;
  }

  void signInWithPhone({required BuildContext context, required String phoneNumber}) async {
    final response = await authRepository.signInWithPhone(context: context, phoneNumber: phoneNumber);

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => null,
    );
  }

  void verifyOTP({required BuildContext context, required String verificationId, required String userOTP}) async {
    final response = await authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          UserInformationScreen.routeName, 
          (route) => false,
        );
      },
    );
  }

  void saveUserDataToFirebase(BuildContext context, String name, File? profilePicture) async {
    final response = await authRepository.saveUserDataToFirebase(
      context: context, 
      name: name, 
      profilePicture: profilePicture, 
      ref: ref,
    );

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MobileScreenLayout.routeName, 
          (route) => false,
        );
      },
    );
  }

  Stream<UserModel> userDataById(String uid) {
    return authRepository.userData(uid);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}