import 'dart:io';
import 'package:donor_tracker/modal/userModal.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:donor_tracker/Widget/bezierContainer.dart';
import 'package:donor_tracker/landing_screen.dart';
import 'package:donor_tracker/loginPage.dart';
import 'package:donor_tracker/main.dart';
import 'package:donor_tracker/modal/preferenceModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController name = TextEditingController();
  TextEditingController blood = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  Widget _entryField(String title, bool isBlood, TextEditingController cont,
      {bool isPassword = false}) {
    if (!isBlood)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: cont,
                validator: (a) {
                  if (a.isEmpty) {
                    return 'Field Cannot be Empty';
                  }
                  return null;
                },
                obscureText: isPassword,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true))
          ],
        ),
      );
    else
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: DropdownButton<String>(
                value: dropdownValue,
                underline: Container(
                  height: 0,
                  color: Colors.blue[400],
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        try {
          Map temp = {
            "name": name.text.trimRight(),
            "blood_group": dropdownValue.trimRight(),
            "email": email.text.trimRight(),
            "contact": number.text.trimRight(),
            "password": password.text.trimRight()
          };
          Response r = await Dio().post('$domain/createUser', data: temp);
          if (r.statusCode == 200) {
            if(r.data['status']=="success") {
              if(await PreferenceModal().setFirstTimeScreen(true)&& await PreferenceModal().setUserData(temp))
                await PreferenceModal().setIsLogin(true);
                Navigator.push(context, CupertinoPageRoute(builder:(context)=>LandingScreen()));
            }
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.red[200], Colors.red[500]])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Don',
          style: GoogleFonts.portLligatSans(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'orTr',
              style: TextStyle(color: Colors.amber[300], fontSize: 30),
            ),
            TextSpan(
              text: 'acker',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      child: Column(
        children: <Widget>[
          _entryField("Name", false, name),
          _entryField("Blood Group", true, blood),
          _entryField("Email Id", false, email),
          _entryField("Mobile Number", false, number),
          _entryField("Password", false, password, isPassword: true),
          _entryField("Confirm Password", false, confirm, isPassword: true),
        ],
      ),
    );
  }

  String dropdownValue = 'O+';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30,),
                    _title(),
                     _emailPasswordWidget(),
                     _submitButton(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _loginAccountLabel(),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
