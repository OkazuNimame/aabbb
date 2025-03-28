import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ButtonView extends StatelessWidget{
  String json;
   VoidCallback v;

  ButtonView({required this.json,required this.v});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: v
      ,child: Lottie.asset("$json"),
    );
  }
}