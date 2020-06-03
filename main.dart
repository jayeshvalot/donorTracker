import 'package:donor_tracker/modal/userModal.dart';
import 'package:donor_tracker/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
  ChangeNotifierProvider(create: (context) => User(),),
], child: MyApp()));
var domain = 'http://103.35.165.198:3006/donar/';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Donor Tracker',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SplashScreen());
  }
}
