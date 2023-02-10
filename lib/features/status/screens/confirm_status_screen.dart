import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/colors.dart';
import '../controller/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName = '/confirm-status-screen';
  const ConfirmStatusScreen({super.key, required this.file});

  final File file;

  void addStatus(BuildContext context, WidgetRef ref) {
    ref.read(statusControllerProvider).addStatus(context, file);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9/16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () => addStatus(context, ref),
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}