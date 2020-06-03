import 'package:donor_tracker/edit_profile.dart';
import 'package:donor_tracker/modal/preferenceModal.dart';
import 'package:donor_tracker/style/colorSheet.dart';
import 'package:donor_tracker/style/textStyle.dart';
import 'package:donor_tracker/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:donor_tracker/landing_screen.dart';
import 'dart:math' as math;

Map data;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // getData() async {
  //   data = await PreferenceModal().getUserData();
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 230,
              child: Stack(
                children: <Widget>[
                  Transform.rotate(
                    angle: -math.pi / 9,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[200], Colors.red[500]],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50))),
                    ),
                  ),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[200], Colors.red[500]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: MediaQuery.of(context).size.width - 150,
                    child: Hero(
                      tag: 'userProfile',
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: AssetImage('image/profile.jpg'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 110),
                    child: Text(
                      userData['name'],
                      style: textBoldBlack28,
                    ),
                  ),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[200], Colors.red[500]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: iconColorBlack,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        title: Text(
                          'My Profile',
                          style: textBlack24,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: iconColorBlack,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => EditProfile()));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32.0,
                      right: 32.0,
                    ),
                    child: IgnorePointer(
                      child: TextFormField(
                        initialValue: userData['email'],
                        decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 32.0),
                    child: IgnorePointer(
                      child: TextFormField(
                        initialValue: userData['name'],
                        decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: mainColor),
                            contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 32.0),
                    child: IgnorePointer(
                      child: TextFormField(
                        initialValue: userData['contact'],
                        decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(color: mainColor),
                            contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 32.0),
                    child: IgnorePointer(
                      child: TextFormField(
                        initialValue: userData['blood_group'],
                        decoration: InputDecoration(
                            labelText: 'Blood Group',
                            labelStyle: TextStyle(color: mainColor),
                            contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await PreferenceModal().setIsLogin(false)) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => WelcomePage()),
                            ModalRoute.withName('/'));
                      }
                    },
                    child: Container(
                      height: 40,
                      margin:
                          EdgeInsets.symmetric(vertical: 32, horizontal: 32),
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
                        'Log Out',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
