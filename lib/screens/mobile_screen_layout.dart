import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../colors.dart';
import '../features/auth/controller/auth_controller.dart';
import '../features/select_contacts/screens/select_contact_screen.dart';
import '../features/chat/widgets/contacts_list.dart';
import '../models/user.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  static const String routeName = '/mobile-screen';
  const MobileScreenLayout({super.key, this.user});

  final UserModel? user;

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(userProvider.notifier).update((state) {
          if (widget.user != null) {
            return widget.user;
          }
          return state;
        });
      },
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          centerTitle: false,
          elevation: 0,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold
            ),
          ),
          actions: <Widget> [
            IconButton(
              onPressed: () {}, 
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {}, 
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: greenColor,
            indicatorWeight: 4,
            labelColor: greenColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: <Widget> [
              Tab(text: 'CHATS',),
              Tab(text: 'STATUS',),
              Tab(text: 'CALLS',),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () => Navigator.pushNamed(context, SelectContactScreen.routeName),
          backgroundColor: greenColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}