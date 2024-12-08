import 'package:flutter/material.dart';
import 'package:hydroviz/screens/login_signup/login_Button.dart';
import 'package:hydroviz/screens/login_signup/login_TextField.dart';
import 'package:hydroviz/utils/app_style.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void hello() {}
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
            onTap: () {
              //Needs logic
              print("Sign Up button tapped!");
            },
          ),
          const SizedBox(height: 30),
        ],
      ))),
    );
  }
}
