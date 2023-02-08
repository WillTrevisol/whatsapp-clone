import 'package:flutter/material.dart';

import 'core/common/widgets/error_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/user_information_screen.dart';
import 'features/select_contacts/screens/select_contact_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'screens/mobile_screen_layout.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OTPScreen.routeName:
      return MaterialPageRoute(builder: (context) => OTPScreen(verificationId: settings.arguments as String));

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => const UserInformationScreen());
    
    case MobileScreenLayout.routeName:
      return MaterialPageRoute(builder: (context) => const MobileScreenLayout());

    case SelectContactScreen.routeName: 
      return MaterialPageRoute(builder: (context) => const SelectContactScreen());
    
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(builder: (context) => MobileChatScreen(
        name: arguments['name'], 
        uid: arguments['uid'],
      ));
    
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold(body: ErrorScreen(message: 'Page not Found')));
  }
}