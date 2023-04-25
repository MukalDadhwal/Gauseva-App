import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gauseva_app/controllers/authController.dart';
import 'package:gauseva_app/screens/opt_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:get/get.dart';

import '../screens/login_screen.dart';

class SignUpPageForNormalUser extends StatefulWidget {
  static String verificationCode = "";
  static bool isGauraksak = true;

  @override
  State<SignUpPageForNormalUser> createState() =>
      _SignUpPageForNormalUserState();
}

class _SignUpPageForNormalUserState extends State<SignUpPageForNormalUser>
    with SingleTickerProviderStateMixin {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  late AnimationController _controller;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController());
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.forward();
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

  Future<void> sendOtp({bool onSignUpPage = false}) async {
    String username = _usernameController.text.trim();
    String phonenumber = "+91 ${_phoneNumberController.text.trim()}";

    if (username.length == 0) {
      showSnackBar('Please enter a username');
      return;
    }

    if (username.length > 20) {
      showSnackBar('Username must be smaller than 20 characters');
      return;
    }

    if (_phoneNumberController.text.trim().length != 10) {
      showSnackBar('Invalid phone number');
      return;
    }

    await _authController
        .signUpUser(
      phonenumber: phonenumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar('try again later...');
        return;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: onSignUpPage
          ? (String verificationId, int? resendToken) {
              SignUpPageForNormalUser.verificationCode = verificationId;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => OtpScreen(
                    phonenumber: phonenumber,
                    sendOtp: sendOtp,
                    calledBySignUp: true,
                    userName: username,
                    isGauraksak: true,
                  ),
                ),
              );
            }
          : (String verificationId, int? resendToken) {
              SignUpPageForNormalUser.verificationCode = verificationId;
            },
    )
        .onError(
      (_, __) {
        showSnackBar('try again later...');
      },
    );
  }

  Future<void> _navigateToLoginPage() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginPage(),
        transitionDuration: Duration(seconds: 2),
        transitionsBuilder: (_, a, b, c) => SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1, 0),
            end: Offset.zero,
          ).animate(_controller),
          child: c,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    'assets/cow_image.jpg',
                    height: 20.h,
                    width: 50.w,
                  ),
                  alignment: Alignment.center,
                ),
                Text(
                  'Get On Board!',
                  style: GoogleFonts.raleway(
                      fontSize: 28.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 6),
                Text(
                  'Create your profile',
                  style: GoogleFonts.raleway(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  height: 8.h,
                  child: TextField(
                    controller: _usernameController,
                    cursorHeight: 20.sp,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Full Name',
                      hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.black,
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
                ),
                SizedBox(height: 10),
                Container(
                  height: 8.h,
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    cursorHeight: 20.sp,
                    cursorColor: Colors.black,
                    maxLengthEnforcement:
                        MaxLengthEnforcement.truncateAfterCompositionEnds,
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
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (await _authController
                        .alreadyRegistered(_phoneNumberController.text)) {
                      showSnackBar(
                          'You are already registered try using logging in!');
                      Get.toNamed('/login-page');
                    } else {
                      await sendOtp(onSignUpPage: true);
                    }
                  },
                  child: Text(
                    "Sign Up",
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
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already a user?',
                          style: GoogleFonts.raleway(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' login',
                          style: GoogleFonts.raleway(
                            fontSize: 12.sp,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _navigateToLoginPage,
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

class SignUpPageForGaushala extends StatefulWidget {
  static bool isGauraksak = false;
  @override
  State<SignUpPageForGaushala> createState() => _SignUpPageForGaushalaState();
}

class _SignUpPageForGaushalaState extends State<SignUpPageForGaushala> {
  TextEditingController _gaushalaNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberOfCowsController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _youtubeController = TextEditingController();

  int _currentStep = 0;

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text("Account"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _gaushalaNameController,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Gaushala Name',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Phone No.',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'E-Mail',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.mail_outline_outlined,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _numberOfCowsController,
              keyboardType: TextInputType.phone,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Number of Cows',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Address"),
        content: Column(
          children: [
            TextField(
              controller: _addressController,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Address',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _districtController,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'District',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.pin_drop_outlined,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _pincodeController,
              keyboardType: TextInputType.phone,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Pincode',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.pin_outlined,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: Row(
          children: [
            Text(
              "Social",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.left,
            ),
            Text(
              "  (*optional)",
              style: GoogleFonts.raleway(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        content: Column(
          children: [
            TextField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: ' Website link',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.link,
                    color: Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _facebookController,
              keyboardType: TextInputType.url,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: ' Facebook link',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(
                    FontAwesome.facebook,
                    color: Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _twitterController,
              keyboardType: TextInputType.url,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: ' Twitter link',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(
                    FontAwesome.twitter,
                    color: Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _youtubeController,
              keyboardType: TextInputType.url,
              cursorHeight: 16.sp,
              cursorColor: Colors.black,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: ' Youtube link',
                hintStyle: GoogleFonts.raleway(fontSize: 13.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(
                    FontAwesome.youtube,
                    color: Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 1.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Image.asset(
                  'assets/cow_image.jpg',
                  height: 20.h,
                  width: 50.w,
                ),
                alignment: Alignment.center,
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(
                  'Get On Board!',
                  style: GoogleFonts.raleway(
                      fontSize: 28.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(
                  'Register with us as a Gaushala',
                  style: GoogleFonts.raleway(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: 100.w,
                height: 60.h,
                padding: const EdgeInsets.all(0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.green,
                    ),
                  ),
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    steps: getSteps(),
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: details.onStepContinue,
                            child: Text('Continue'),
                          ),
                          _currentStep == 0
                              ? SizedBox.shrink()
                              : TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('Back'),
                                ),
                        ],
                      );
                    },
                    onStepCancel: () => _currentStep == 0
                        ? null
                        : setState(() {
                            _currentStep -= 1;
                          }),
                    onStepContinue: () {
                      bool isLastStep = (_currentStep == getSteps().length - 1);
                      if (isLastStep) {
                        // Show a popup for confirming the registeration
                      } else {
                        setState(() {
                          _currentStep += 1;
                        });
                      }
                    },
                    onStepTapped: (step) => setState(() {
                      _currentStep = step;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
