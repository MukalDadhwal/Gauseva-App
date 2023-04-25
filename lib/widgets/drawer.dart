import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/authController.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.greenAccent,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save',
                  style: GoogleFonts.openSans(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Lives !',
                  style: GoogleFonts.openSans(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Log out'),
            onTap: () {
              Get.find<AuthController>().instance.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Version'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Terms and Conditions'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
