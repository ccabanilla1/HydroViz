import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final double paddingLT;
  final VoidCallback onTap;

  const LoginButton(
      {super.key,
      required this.text,
      required this.paddingLT,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.fromLTRB(paddingLT, 10, paddingLT, 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))));
  }
}
