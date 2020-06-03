import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:donor_tracker/landing_screen.dart';
import 'package:donor_tracker/main.dart';
import 'package:donor_tracker/modal/preferenceModal.dart';
import 'package:donor_tracker/style/colorSheet.dart';
import 'package:donor_tracker/style/textStyle.dart';
import 'package:donor_tracker/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
  }

  String dropdownValue;
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Edit Profile', style: textBlack24),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Stack(
                  alignment: FractionalOffset.bottomRight,
                  children: <Widget>[
                    Hero(
                      tag: 'userProfile',
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: AssetImage('image/profile.jpg'),
                      ),
                    ),
                    FloatingActionButton(
                      elevation: 0,
                      mini: true,
                      onPressed: () {},
                      child: Icon(
                        Icons.camera_alt,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 32.0),
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 32.0),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: mainColor),
                          contentPadding: EdgeInsets.all(8)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 32.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: number,
                      decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(color: mainColor),
                          contentPadding: EdgeInsets.all(8)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, left: 38.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Blood Group',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 34.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
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
            ),
            InkWell(
              onTap: () async {
                try {
          Map temp = {
            "name": name.text.trimRight(),
            "blood_group": dropdownValue.trimRight(),
            "email": email.text.trimRight(),
            "contact": number.text.trimRight(),
          };
          print(temp);
          Response r = await Dio().put('$domain/updateUser', data: temp);
          if (r.statusCode == 200) {
            print(r.data);
            if(r.data['status']=="success") {
              if(await PreferenceModal().setUserData(temp))
                Navigator.push(context, CupertinoPageRoute(builder:(context)=>LandingScreen()));
            }
          }
        } catch (e) {
          print(e);
        }
              },
              child: Container(
                height: 40,
                margin: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
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
                  'Update Profile',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      name.text = userData['name'];
      email.text = userData['email'];
      number.text = userData['contact'];
      dropdownValue = userData['blood_group'];
    });
  }
}
