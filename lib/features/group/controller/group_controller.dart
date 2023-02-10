import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/utils.dart';
import '../repository/group_repository.dart';

final groupControllerProvider = Provider(
  (ProviderRef ref) => GroupController(
    groupRepository: ref.read(groupRepositoryProvider), 
    ref: ref
  ),
);

class GroupController {
  
  final GroupRepository groupRepository;
  final ProviderRef ref;
  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(BuildContext context, String groupName, File file, List<Contact> contacts) async {
    final response = await groupRepository.createGroup(groupName, file, contacts);

    response.fold(
      (left) => showSnackBar(context: context, message: left.message),
      (right) => null,
    );
  }
}
