import 'package:flutter/material.dart';

class LoginTextfield extends StatelessWidget {
  final controller;
  final String textHint;
  final bool hideText;

  const LoginTextfield({
    super.key, 
    required this.controller,
    required this.textHint,
    required this.hideText
  });
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hideText,
      
      showCursor: true,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.amber)
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.blue)
        ),
        hintText: textHint

        
      ),
    );
  }
}