import 'package:flutter/material.dart';
import 'package:gauseva_app/controllers/authController.dart';
import 'package:gauseva_app/screens/login_screen.dart';
import './screens/opt_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../screens/tab_screen.dart';
import './screens/signup_screen.dart';
import './controllers/authBinding.dart';

/* 
TODO:

add username discretion for keeping original name
severity in post 
No. of cows seen
make the dropdown with circular border


local notification is when image is uploaded successfully 
signup and login logic for gaushala 
firestore connection for both 
create option for hide and unhide password
while user is entering a password check whether password is strong and show label accordingly  
Remove controllers and animation controllers in dispose

*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, orientation, deviceType) {
        return GetMaterialApp(
          initialBinding: AuthBinding(),
          title: 'Gauseva',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          home: Obx(
            (() => Get.find<AuthController>().user != null
                ? TabScreen()
                : SignUpPageForNormalUser()),
          ),
          routes: {
            '/sign-up-normal': (context) => SignUpPageForNormalUser(),
            // '/': (context) => SignUpPageForGaushala(),
            '/sign-up-gaushala': (context) => SignUpPageForGaushala(),
            '/login-page': (context) => LoginPage(),
          },
        );
      },
    );
  }
}
