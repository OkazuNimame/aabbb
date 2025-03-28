import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackGroundColor extends StatelessWidget{
  Color color;
  Widget child;

  BackGroundColor({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10), // TextField の内側に余白を作る
      margin: EdgeInsets.symmetric(horizontal: 10), // 外側にはみ出す余白
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: child,
    );
  }

}