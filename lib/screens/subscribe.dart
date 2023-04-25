import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../styles/button.dart';
import '../styles/color.dart';
import '../styles/typo.dart';

class SubscribeCreator extends StatefulWidget {
  @override
  State<SubscribeCreator> createState() => _SubscribeCreatorState();
}

class _SubscribeCreatorState extends State<SubscribeCreator> {
  var selectedPayment = "VISA";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Image.network(
            "https://cdn.discordapp.com/attachments/1099757687513821265/1099757967689121822/Logo-1.webp",
            width: 50.w,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Text(
                'Gauseva Foundation',
                style: price,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              // print('hey');
              // await launchUrl(Uri.parse('https://gauseva.co.in/'));
            },
            child: Text(
              'www.gauseva.co.in/',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About',
                style: subheader,
              ),
              SizedBox(height: 12),
              Text(
                'Gauseva functions as an open platform for people and groups to donate their fair share of kindness by making donations to our existing or prospective gaushala projects.',
                style: p,
              ),
            ],
          ),
          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectPayment('UPI payment', ''),
            ],
          ),
          SizedBox(height: 50),
          ElevatedButton(
            style: buttonPrimary,
            onPressed: () {},
            child: Text(
              'Support Now',
              style: labelPrimary,
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: Text(
              'Terms & Conditions',
              style: labelSecondary,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _selectPayment(String title, String image) {
    return InkWell(
      onTap: () {
        selectPayment(title);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: title == selectedPayment ? white : Colors.transparent,
          border: title == selectedPayment
              ? Border.all(width: 1, color: Colors.transparent)
              : Border.all(width: 1, color: grey),
        ),
        child: Container(
          width: double.infinity,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.black),
                ),
                Spacer(),
                // Image.asset(image, height: 23),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectPayment(title) {
    setState(() {
      selectedPayment = title;
    });
  }
}
