import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'colors.dart';
import 'core/common/widgets/error_screen.dart';
import 'core/common/widgets/loading_widget.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/landing/screens/landing_screen.dart';
import 'firebase_options.dart';
import 'router.dart';
import 'screens/mobile_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Clone',
      theme: ThemeData.dark().copyWith(
        primaryColor: greenColor,
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: greenColor,
          fillColor: greenColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataProvider).when(
        data: (data) {
          if (data == null) {
            return const LandingScreen();
          }

          return MobileScreenLayout(user: data);
        },
        error: (error, stackTrace) => ErrorScreen(message: error.toString()),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
