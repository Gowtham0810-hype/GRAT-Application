import 'package:flutter/material.dart';

class Textfieldcustom extends StatelessWidget {
  final controller;
  final String hinttext;
  final bool obscuretext;

  const Textfieldcustom({super.key,required this.controller,required this.hinttext,required this.obscuretext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        decoration: InputDecoration(
          
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            fillColor: Colors.white54,
            filled: true,
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.grey.shade500)),
            
      ),
    );
  }
}
