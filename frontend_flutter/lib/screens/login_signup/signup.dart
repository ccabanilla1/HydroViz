import 'package:flutter/material.dart';
import 'package:hydroviz/screens/login_signup/login_Button.dart';
import 'package:hydroviz/screens/login_signup/login_text_field.dart';
import 'package:hydroviz/utils/app_style.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> signUpUser(BuildContext context) async {
    var url = Uri.parse('http://0.0.0.0:8000/auth/signup/');
    try {
      var response = await http.post(url, body: {
        'email': emailController.text,
        'password': passwordController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text
      });
      if (response.statusCode == 201) {
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
          child: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.fromLTRB(370, 0, 0, 0),
              child: Row(
                children: [
                  Text('SignUp', style: TextStyle(fontSize: 50)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
                child: LoginTextfield(
                  controller: firstNameController,
                  textHint: "First Name",
                  hideText: false,
                )),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
                child: LoginTextfield(
                  controller: lastNameController,
                  textHint: "Last Name",
                  hideText: false,
                )),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
                child: LoginTextfield(
                  controller: emailController,
                  textHint: "Email",
                  hideText: false,
                )),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
                child: LoginTextfield(
                  controller: passwordController,
                  textHint: "Password",
                  hideText: true,
                )),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
                child: LoginTextfield(
                  controller: confirmPasswordController,
                  textHint: "Confirm Password",
                  hideText: true,
                )),
            const SizedBox(height: 30),
            LoginButton(
              text: 'Sign Up',
              paddingLT: 50,
              onTap: () async {
                await signUpUser(context);
              },
            ),
            const SizedBox(height: 30),
          ],
        )),
      )),
    );
  }
}
