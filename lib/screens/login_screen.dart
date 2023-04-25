import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './opt_screen.dart';
import '../controllers/authController.dart';

class LoginPage extends StatefulWidget {
  static String verificationCode = "";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneNumberController = TextEditingController();

  Future<void> loginInUser({bool onSignUpPage = false}) async {
    AuthController _authController = Get.find<AuthController>();
    String phonenumber = "+91 ${_phoneNumberController.text}";
    await _authController
        .signUpUser(
      phonenumber: phonenumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: onSignUpPage
          ? (String verificationId, int? resendToken) {
              LoginPage.verificationCode = verificationId;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => OtpScreen(
                    phonenumber: phonenumber,
                    calledBySignUp: false,
                    sendOtp: loginInUser,
                  ),
                ),
              );
            }
          : (String verificationId, int? resendToken) {
              LoginPage.verificationCode = verificationId;
            },
    )
        .onError(
      (error, _) {
        Get.closeCurrentSnackbar();
        Get.showSnackbar(
          GetSnackBar(
            duration: Duration(seconds: 3),
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            dismissDirection: DismissDirection.horizontal,
            borderRadius: 10.0,
            titleText: Text(
              'Something Went Wrong',
              style: GoogleFonts.raleway(
                color: Colors.white,
              ),
            ),
            messageText: Text(
              'Try Again Later...',
              style: GoogleFonts.raleway(
                color: Colors.grey,
                fontSize: 10.sp,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'assets/cow_image.jpg',
                    height: 20.h,
                    width: 50.w,
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.raleway(
                      fontSize: 28.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  cursorHeight: 20.sp,
                  cursorColor: Colors.black,
                  maxLength: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'Phone No.',
                    hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                    prefixIcon: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 15, right: 20),
                      child: Text(
                        '+91',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await loginInUser(onSignUpPage: true);
                  },
                  child: Text(
                    "Login",
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    minimumSize: Size.fromHeight(6.h),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
