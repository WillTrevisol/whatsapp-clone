
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  const OTPScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  final String verificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void verifyOTP(BuildContext context, String userOTP) {
      ref.read(authControllerProvider).verifyOTP(
        context: context, 
        verificationId: verificationId, 
        userOTP: userOTP,
      );
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
      ),
      body: Column(
        children: <Widget> [
          const SizedBox(height: 20),
          const Text('We have sent you and SMS with a code'),
          Center(
            child: SizedBox(
              width: size.width * 0.5,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOTP(context, value.trim());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
