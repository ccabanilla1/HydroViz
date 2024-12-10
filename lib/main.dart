import 'package:flutter/material.dart';
import 'package:hydroviz/login_signup/login.dart';
import 'package:hydroviz/login_signup/reset.dart';
import 'package:hydroviz/login_signup/signup.dart';
import 'package:hydroviz/screens/mainscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login':(context) => Login(),
        '/signup':(context) => SignUp(),
        '/mainscreen':(context) => const  MainScreen(),
        '/resetpassword':(context) => Reset()
      },
    );
  }
}

