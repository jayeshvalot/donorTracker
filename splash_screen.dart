import 'dart:async';

import 'package:donor_tracker/landing_screen.dart';
import 'package:donor_tracker/modal/preferenceModal.dart';
import 'package:donor_tracker/slider_screen.dart';
import 'package:donor_tracker/style/textStyle.dart';
import 'package:donor_tracker/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  firstCall() {
    Timer(Duration(seconds: 4), () async{
      if(!await PreferenceModal().getFirstTimeScreen()) {
        Navigator.push(
          context, CupertinoPageRoute(builder: (context) => SliderScreen()));
      }
      else if(await PreferenceModal().getIsLogin()) {
        Navigator.push(
          context, CupertinoPageRoute(builder: (context) => LandingScreen()));
      }
      else {
        Navigator.push(
          context, CupertinoPageRoute(builder: (context) => WelcomePage()));
      }
      
    });
  }
  
  @override
  void initState() {
    super.initState();
    firstCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
          ),
          HeartbeatProgressIndicator(
              child: Icon(
            FontAwesomeIcons.heartbeat,
            color: Colors.red,
            size: 50,
          )),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              'Please Wait. . .',
              style: textBoldBlack20,
            ),
          ))
        ],
      ),
    );
  }
}
