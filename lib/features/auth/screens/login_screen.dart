import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/utils/colors.dart';
import '../../../core/common/utils/utils.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final TextEditingController phoneController = TextEditingController();
  Country? country;

  void sendPhoneNumber(String phoneNumber) {
    if (country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(context: context, phoneNumber: '+${country?.phoneCode}$phoneNumber');
      return;
    }

    showSnackBar(context: context, message: 'Please enter your phone number.', isError: true);
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        backgroundColor: backgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                const Text('WhatsApp will need to verify your phone number'),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context, 
                      onSelect: (Country selected) {
                        setState(() => country = selected);
                      },
                    );
                  }, 
                  child: const Text('Pick your country'),
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget> [
                    if (country != null)
                      Text('+${country?.phoneCode}'),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'phone number',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 22),
            child: CustomButton(
              onPressed: () => sendPhoneNumber(phoneController.text.trim()),
              text: 'NEXT',
            ),
          ),
        ],
      ),
    );
  }
}