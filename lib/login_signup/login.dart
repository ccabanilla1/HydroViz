import 'package:flutter/material.dart';
import 'package:hydroviz/login_signup/login_button.dart';
import 'package:hydroviz/login_signup/login_text_field.dart';
import 'package:hydroviz/utils/app_style.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Login extends StatelessWidget {
  Login({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async{
    var url = Uri.parse('http://0.0.0.0:8000/auth/login/');
    try{
      var response = await http.post(url, body: {
        'email': emailController.text,
        'password': passwordController.text,
      });

      if(response.statusCode == 200){
        Navigator.pushNamed(context, '/mainscreen');
      }
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    catch(e){
      print('Error: $e' );
    }
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
                      controller: emailController,
                      textHint: "Email",
                      hideText: false,
                    ) 
                  ),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
                    child: LoginTextfield(
                      controller: passwordController,
                      textHint: "Password",
                      hideText: true,
                    ) 
                  ),
                  
                  const SizedBox(height: 20),

                  Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 350),
                    child:  Row(
                      
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, '/resetpassword');
                          },
                          child: const Text(
                            'Forgot Password?', 
                            style: TextStyle()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoginButton(
                    text: 'Sign In', 
                    paddingLT: 50, 
                    onTap: ()async{
                      await loginUser(context);
                    },),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       const Text('Not a member?'),
                       const SizedBox(width: 4),
                       GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/signup');},
                        child: const Text(
                          'Sign Up', 
                          style: TextStyle(color: Colors.blueAccent))),
                    ],
                  )
                ],
              ))),
    );
  }
}