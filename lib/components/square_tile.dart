// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final imagepath;
  const SquareTile({super.key,required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        
        
        border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(15),color: Colors.white60),
      child: Image.asset(imagepath,height: 69,),
    );
  }
}
