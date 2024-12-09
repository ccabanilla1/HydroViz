import 'package:flutter/material.dart';
import 'package:hydroviz/login_signup/login_button.dart';
import 'package:hydroviz/login_signup/login_text_field.dart';
import 'package:hydroviz/utils/app_style.dart';

class Reset extends StatelessWidget {
  Reset({super.key});
  final usernameController = TextEditingController();

  void hello(){
    
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
                      Text('Enter the email associated with your account and', 
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                      SizedBox(height: 1,),
                      Text('we\'ll send you password reset instructions.',
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                    ],
                  ),
        
                  const SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(350, 0, 350, 0),
                    child: LoginTextfield(
                      controller: usernameController,
                      textHint: "Email",
                      hideText: false,
                    ) 
                  ),

                  

                  
                  
              
                  
                  const SizedBox(height: 30),
                  
                  LoginButton(text: 'Send reset Link', paddingLT: 50,onTap: (){},),
                  const SizedBox(height: 30),
                  
                ],
              ))),
    );
  }
}