import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'backgroundColor.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget  {
  final String title;

  final dynamic? n;

  final ElevatedButton? button;

  final VoidCallback? v;


  AppBarBase({required this.title,this.n,this.button,this.v});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title), // $titleではなく、直接titleを使用
      backgroundColor: Colors.blue,
      actions:  button != null? [BackGroundColor(color: Colors.red,child: button!,)]:null,
      leading: n != null? IconButton(onPressed: (){
        v?.call();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => n));
      },icon: Icon(Icons.arrow_back),):null
    );
  }

  @override
  // AppBarの高さを設定
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
