import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    void navigateToLoginScreen() {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            const SizedBox(height: 50),
            const Text(
              'Welcome to WhatsApp',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: size.height / 9),
            Image.asset(
              'assets/bg.png',
              height: 340,
              width: 340,
              color: greenColor,
            ),
            SizedBox(height: size.height / 9),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.85,
              child: CustomButton(
                onPressed: () => navigateToLoginScreen(),
                text: 'AGREE AND CONTINUE',
              ),
            ),
          ],
        ),
      ),
    );
  }
}