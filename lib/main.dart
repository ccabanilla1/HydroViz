import 'package:flutter/material.dart';
import 'package:hydroviz/login_signup/reset.dart';
// import 'package:hydroviz/utils/app_style.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Reset(),
    );
  }
}