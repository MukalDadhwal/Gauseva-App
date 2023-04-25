import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controllers/authController.dart';
import './login_screen.dart';
import './signup_screen.dart';
import 'tab_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phonenumber;
  final Future<void> Function() sendOtp;
  final bool calledBySignUp;
  final String userName;
  final bool isGauraksak;

  OtpScreen({
    required this.phonenumber,
    required this.sendOtp,
    required this.calledBySignUp,
    this.userName = "",
    this.isGauraksak = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _pinInputController = TextEditingController();

  Future<void> _loginUser(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginPage.verificationCode,
        smsCode: smsCode,
      );
      AuthController auth = Get.find<AuthController>();
      await auth.instance.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }
  }

  Future<void> _signUpUser(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: SignUpPageForNormalUser.verificationCode,
        smsCode: smsCode,
      );
      AuthController auth = Get.find<AuthController>();
      await auth.instance.signInWithCredential(credential);

      await auth.registerUserInDatabase(
        widget.userName,
        widget.phonenumber,
        widget.isGauraksak,
      );
    } catch (e) {
      throw e;
    }
  }

  void showSnackBar(String msg) {
    GetSnackBar snackbar = GetSnackBar(
      duration: Duration(seconds: 3),
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      dismissDirection: DismissDirection.horizontal,
      borderRadius: 10.0,
      titleText: Text(
        'Something went wrong',
        style: GoogleFonts.raleway(
          color: Colors.white,
        ),
      ),
      messageText: Text(
        msg,
        style: GoogleFonts.raleway(
          color: Colors.grey,
          fontSize: 10.sp,
        ),
      ),
    );
    Get.closeCurrentSnackbar();
    Get.showSnackbar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Verification',
                    style: GoogleFonts.raleway(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Enter the code sent to the number',
                    style: GoogleFonts.raleway(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    widget.phonenumber,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Pinput(
                  length: 6,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                  controller: _pinInputController,
                  onCompleted: (String code) async {
                    try {
                      if (widget.calledBySignUp) {
                        await _signUpUser(code).onError((_, __) {
                          showSnackBar('');
                        }).then((value) {
                          Get.back();
                          Get.back();
                        });
                      } else {
                        await _loginUser(code).onError((_, __) {
                          showSnackBar('');
                        }).then((_) {
                          Get.back();
                          Get.back();
                        });
                      }
                    } catch (_) {
                      Get.closeCurrentSnackbar();
                      Get.showSnackbar(
                        GetSnackBar(
                          duration: Duration(seconds: 3),
                          isDismissible: true,
                          snackStyle: SnackStyle.FLOATING,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 10.0,
                          ),
                          dismissDirection: DismissDirection.horizontal,
                          borderRadius: 10.0,
                          titleText: Text(
                            'Something went wrong here...',
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                            ),
                          ),
                          messageText: Text(
                            'make sure the code entered is correct',
                            style: GoogleFonts.raleway(
                              color: Colors.grey,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 70),
                Container(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Didn\'t receive code?\n',
                          style: GoogleFonts.raleway(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Resend',
                          style: GoogleFonts.raleway(
                            fontSize: 12.sp,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await widget.sendOtp;
                              _pinInputController.clear();
                            },
                        )
                      ],
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
