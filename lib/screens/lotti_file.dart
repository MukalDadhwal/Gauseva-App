import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(children: [
        SizedBox(height: 35),
        Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_8Gr1sc.json',
        ),
        SizedBox(height: 30),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                'What good is a planet with no one to share it with\n Help us save lives of countless innocents by Joining us.',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ])),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0, // soften the shadow
            spreadRadius: 0.5, //extend the shadow
            offset: Offset(
              5.0,
              5.0,
            ),
          ),
        ],
      ),
    );
  }
}
