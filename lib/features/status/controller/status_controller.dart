import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/utils.dart';
import '../../../models/status.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/status_repository.dart';

final statusControllerProvider = Provider(
  (ProviderRef ref) {
    return StatusController(
      statusRepository: ref.read(statusRepositoryProvider), 
      ref: ref,
    );
  },
);

class StatusController {

  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository, 
    required this.ref,
  });

  void addStatus(BuildContext context, File file) async {
    final user = ref.read(userProvider)!;

    final response = await statusRepository.uploadStatus(
      userName: user.name, 
      profilePicture: user.profilePicture, 
      phoneNumber: user.phoneNumber, 
      statusImage: file,
    );

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => null,
    );
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> status = [];
    final response = await statusRepository.getStatus();

    response.fold(
      (left) => showSnackBar(context: context, message: left.message, isError: true), 
      (right) => status = right as List<Status>,
    );

    return status;
  }

}