import 'dart:io';
import 'package:donor_tracker/modal/preferenceModal.dart';
import 'package:donor_tracker/signup.dart';
import 'package:donor_tracker/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SliderScreen extends StatefulWidget {
  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            AspectRatio(
                aspectRatio: 1.2,
                child: Image.asset(
                  'image/slider.png',
                  fit: BoxFit.fitHeight,
                )),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: Text(
                'Find Your Blood Donor',
                style: textBoldBlack24,
              ),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Anytime',
                style: textBoldBlack24,
              ),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Anywhere',
                style: textBoldBlack24,
              ),
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            PreferenceModal().setFirstTimeScreen(true);
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => SignUpPage()));
          },
          label: Row(
            children: <Widget>[
              Text(
                'Next',
                style: textBoldWhite18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
