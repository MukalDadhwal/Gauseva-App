import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gauseva_app/screens/lotti_file.dart';
import 'package:gauseva_app/screens/map_screen.dart';
import 'package:gauseva_app/screens/profile_screen.dart';
import 'package:gauseva_app/screens/subscribe.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/authController.dart';
import 'package:gauseva_app/screens/donate_screen.dart';
import 'package:gauseva_app/screens/home_screen.dart';
import 'upload_screen.dart';
import '../widgets/drawer.dart';

class TabScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;
  late AuthController _auth;

  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    UploadScreen(),
    SubscribeCreator(),
    Account_Info(),
  ];

  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
  }

  Future<void> setDataAndGetPosts() async {
    await _auth.searchAndSetUserData();
    await _auth.getUserPosts();
  }

  String _buildTitle() {
    if (_currentIndex == 0) {
      return 'HomePage';
    } else if (_currentIndex == 1) {
      return 'Hotspots near ${_auth.userData['username']}';
    } else if (_currentIndex == 2) {
      return 'Upload';
    } else {
      return 'Donate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setDataAndGetPosts(),
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Something went wrong while loading user data...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0.0,
            automaticallyImplyLeading: true,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.greenAccent,
            title: Text(
              _buildTitle(),
              style: GoogleFonts.raleway(fontSize: 20),
            ),
          ),
          drawer: DrawerWidget(),
          body: _screens[_currentIndex],
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            itemPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home_rounded),
                title: Text("Home"),
                selectedColor: Colors.greenAccent,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.location_on_rounded),
                title: Text("Map"),
                selectedColor: Colors.greenAccent,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.add_a_photo_rounded),
                title: Text("Upload"),
                selectedColor: Colors.greenAccent,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.price_check_rounded),
                title: Text("Donate"),
                selectedColor: Colors.greenAccent,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile"),
                selectedColor: Colors.greenAccent,
              ),
            ],
          ),
        );
      },
    );
  }
}
