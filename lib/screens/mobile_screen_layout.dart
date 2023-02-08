import 'package:flutter/material.dart';

import '../colors.dart';
import '../features/select_contacts/screens/select_contact_screen.dart';
import '../widgets/contacts_list.dart';

class MobileScreenLayout extends StatelessWidget {
  static const String routeName = '/mobile-screen';
  const MobileScreenLayout({super.key});

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
          onPressed: () => Navigator.of(context).pushNamed(SelectContactScreen.routeName),
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