// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(children: [
        SizedBox(height: 35),
        Lottie.network(
            'https://assets2.lottiefiles.com/packages/lf20_uejd7ezg.json'),
        SizedBox(
          height: 30,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                'Our Application helps in dealing in the problem of\n stray cows by contacting various NGOs & voulantary veterinary clinics\n so that they can give them a new home',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ])),
      decoration: BoxDecoration(
        color: Color(0xfff9f7f7),
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
