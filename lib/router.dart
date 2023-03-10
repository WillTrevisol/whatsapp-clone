import 'dart:io';

import 'package:flutter/material.dart';

import 'core/common/widgets/error_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/user_information_screen.dart';
import 'features/group/screens/create_group_screen.dart';
import 'features/select_contacts/screens/select_contact_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/status/screens/confirm_status_screen.dart';
import 'features/status/screens/status_screen.dart';
import 'models/status.dart';
import 'mobile_screen_layout.dart';

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
        isGroupChat: arguments['isGroupChat'],
        profilePicture: arguments['profilePicture'],
      ));

    case ConfirmStatusScreen.routeName:
      final arguments = settings.arguments as File;
      return MaterialPageRoute(builder: (context) => ConfirmStatusScreen(
        file: arguments,
      ));

    case StatusScreen.routeName:
      final arguments = settings.arguments as Status;
      return MaterialPageRoute(builder: (context) => StatusScreen(
        status: arguments,
      ));

    case CreateGroupScreen.routeName: 
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());
    
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold(body: ErrorScreen(message: 'Page not Found')));
  }
}