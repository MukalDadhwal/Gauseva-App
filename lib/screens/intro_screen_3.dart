// ignore_for_file: prefer_const_constructors
import 'package:gauseva_app/screens/signup_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage3 extends StatefulWidget {
  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xfff9f7f7),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 45),
                      RichText(
                        text: TextSpan(
                          text: "GAUSEVAK\n",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 45),
                      RichText(
                        text: TextSpan(
                          text:
                              "\nWho is a gausevak?\n\n A Gausevak is an individual who represents a \n citizen who is avid to save the lives\n of stray cows\n",
                          style: TextStyle(
                            color: Color(0xff8c8787),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 55),
                      RichText(
                        text: TextSpan(
                          text:
                              "Click below to confirm your role as a\n GAUSEVAK\n",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff8c8787),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Get.to(SignUpPageForGaushala()),
                        icon: Icon(Icons.check),
                        label: Text("Confirm My Role"),
                        /*style: ButtonStyle(
                        backgroundColor: Color(0xff29a267))*/
                      )
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: Color(0xffaea7a7),
                thickness: 1,
                width: 40,
                indent: 20,
                endIndent: 20,
              ),
              Expanded(
                child: Container(
                    child: Column(children: [
                  SizedBox(height: 45),
                  RichText(
                    text: TextSpan(
                      text: "GAURAKSHAK\n",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 45),
                  RichText(
                    text: TextSpan(
                      text:
                          "\nWho is a gaurakshak?\n\n A Gaurakshak is an individual who represents any\n organization under which they can take care\n of stray cows",
                      style: TextStyle(
                        color: Color(0xff8c8787),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 55),
                  RichText(
                    text: TextSpan(
                      text:
                          "Click below to confirm your role as a\n GAURAKSHAK\n",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff8c8787),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(SignUpPageForNormalUser()),
                    icon: Icon(Icons.check),
                    label: Text("Confirm My Role"),
                    /*style: ButtonStyle(
                        backgroundColor: Color(0xff29a267))*/
                  )
                ])),
              ),
            ],
          ),
        ));
  }
}
