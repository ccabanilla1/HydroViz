import 'package:flutter/material.dart';
import 'package:hydroviz/screens/login_signup/login_Button.dart';
import 'package:hydroviz/screens/login_signup/login_text_field.dart';
import 'package:hydroviz/utils/app_style.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final emailController = TextEditingController();

  String responseMessage = '';

  Future<void> loginUser(BuildContext context) async {
    var url = Uri.parse('http://127.0.0.1:8000/auth/login/');
    try {
      var response = await http.post(url, body: {
        'email': emailController.text,
      });
      
      setState(() {
        responseMessage = response.body;
      });
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/login');
      }
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HydroViz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.alternate,
      ),
      backgroundColor: AppColors.primaryBack,
      body: SafeArea(
          child: Center(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.fromLTRB(350, 0, 0, 0),
            child: Row(
              children: [
                Text('Reset Password', style: TextStyle(fontSize: 50)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the email associated with your account and',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                'we\'ll send you password reset instructions.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 350),
                child: Text(
                  responseMessage, 
                  style: const TextStyle(color: Colors.red), 
                  textAlign: TextAlign.center,
                )),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
              child: LoginTextfield(
                controller: emailController,
                textHint: "Email",
                hideText: false,
              )),
          const SizedBox(height: 30),
          LoginButton(
            text: 'Send reset Link',
            paddingLT: 50,
            onTap: () {},
          ),
          const SizedBox(height: 30),
        ],
      ))),
    );
  }
}
