// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Buttonsign extends StatelessWidget {
  final Function()? onTap;
  final String signtext;
  const Buttonsign({super.key, required this.onTap,required this.signtext});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.grey.shade500,
                  offset: Offset(1, 5),
                )
              ],
              color: const Color.fromARGB(255, 5, 89, 157),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Text(
            signtext,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ))),
    );
  }
}
