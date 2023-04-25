import 'package:flutter/material.dart';
import 'package:gauseva_app/controllers/authController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../widgets/profile_menu.dart';

import 'edit_profile_screen.dart';

class Account_Info extends StatefulWidget {
  @override
  State<Account_Info> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<Account_Info> {
  late AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    var username = "wowbanda";
    var phone_number = 9999999999;
    var email_id = "wowbanda@gmail.com";
    var url = "www.wowbanda.com";

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            CircleAvatar(
              child: Icon(Icons.person, size: 45),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              '${_auth.userData['username']}',
              style: GoogleFonts.raleway(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${_auth.userData['phone']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () => Get.to(EditUserProfile()),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 213, 205, 177),
                      side: BorderSide.none,
                      shape: StadiumBorder()),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(color: Color.fromARGB(255, 59, 177, 120)),
                  )),
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 10),
            ProfileMenu(
              title: "Settings",
              icon: Icons.settings,
              onPress: () {},
              textColor: Color.fromARGB(255, 52, 110, 197),
            ),
            ProfileMenu(
              title: "Billing Details",
              icon: Icons.wallet,
              onPress: () {},
              textColor: Color.fromARGB(255, 52, 110, 197),
            ),
            ProfileMenu(
              title: "User Management",
              icon: Icons.account_box_outlined,
              onPress: () {},
              textColor: Color.fromARGB(255, 52, 110, 197),
            ),
            Divider(),
            SizedBox(height: 10),
            ProfileMenu(
              title: "Information",
              icon: Icons.info_outline,
              onPress: () {},
              textColor: Color.fromARGB(255, 52, 110, 197),
            ),
            ProfileMenu(
                title: "Logout",
                icon: Icons.exit_to_app_outlined,
                onPress: _auth.logOutUser,
                textColor: Color.fromARGB(255, 178, 38, 38),
                endIcon: false),
          ],
        ),
      ),
    );
  }
}
