import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/core/common/utils/utils.dart';

import '../colors.dart';
import '../features/auth/controller/auth_controller.dart';
import '../features/group/screens/create_group_screen.dart';
import '../features/select_contacts/screens/select_contact_screen.dart';
import '../features/chat/widgets/contacts_list.dart';
import '../features/status/screens/confirm_status_screen.dart';
import '../features/status/screens/status_contact_screen.dart';
import '../models/user.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  static const String routeName = '/mobile-screen';
  const MobileScreenLayout({super.key, this.user});

  final UserModel? user;

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> 
  with WidgetsBindingObserver, TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    ref.read(authControllerProvider).setUserState(true);
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
    tabController = TabController(length: 3, vsync: this);
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

  void navigateToCreateScreen(BuildContext context) {
    Navigator.pushNamed(
      context, 
      CreateGroupScreen.routeName,
    );
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
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                 PopupMenuItem(
                  child: const Text('Create a group'),
                  onTap: () => Future(() => navigateToCreateScreen(context)),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: greenColor,
            indicatorWeight: 4,
            labelColor: greenColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const <Widget> [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const <Widget> [
            ContactsList(),
            StatusContactsScreen(),
            Text('CALLS'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            if (tabController.index == 0) {
              Navigator.pushNamed(context, SelectContactScreen.routeName);
            }

            if (tabController.index == 1) {
              File? image = await pickImageFromGalery(context);
              if (image != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: image);
              }
            }
          },
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