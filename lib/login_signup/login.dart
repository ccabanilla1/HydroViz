import 'package:flutter/material.dart';
import 'package:hydroviz/login_signup/login_Button.dart';
import 'package:hydroviz/login_signup/login_TextField.dart';
import 'package:hydroviz/main.dart';
import 'package:hydroviz/utils/app_style.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void navigateToHome(BuildContext context) {
    // Perform login validation logic here
    // For now, this goes to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HydroViz'),
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
            padding: EdgeInsets.fromLTRB(370, 0, 0, 0),
            child: Row(
              children: [
                Text('Login', style: TextStyle(fontSize: 50)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
              padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
              child: LoginTextfield(
                controller: usernameController,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 350),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Forgot Password?', style: TextStyle()),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const LoginButton(
            text: 'Sign In',
            paddingLT: 50,
            onTap: () => navigateToHome(context),
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not a member?'),
              SizedBox(width: 4),
              Text('Sign Up', style: TextStyle(color: Colors.blueAccent)),
            ],
          )
        ],
      ))),
    );
  }
}
