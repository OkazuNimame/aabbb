import 'dart:math';

import 'package:aabbb/StudiedTime/ChartPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../AnalysisSubjects/analysis.dart';
import '../RegistrationSubjects/SubjectListPage.dart';

class HomePageView extends StatelessWidget {
  int itemCount;

  HomePageView({required this.itemCount});

  Random random = Random();

  List<dynamic> gradientList1 = [
    Colors.blue, // 明るい青をさらに薄く
    Colors.greenAccent, // 濃い青をさらに薄く
    Colors.amberAccent, // 紫をさらに薄く
  ];

  List<dynamic> gradientList2 = [
    Colors.cyanAccent,
    Colors.lime[100],
    Colors.deepOrange[100]
  ];

  List<String> text = ["登録科目", "分析", "勉強時間"];

  List<Icon> icons = [
    Icon(Icons.class_rounded, size: 150),
    Icon(Icons.analytics_outlined, size: 150),
    Icon(Icons.timer, size: 150)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: PageView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientList1[index], gradientList2[index]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20), // 角を丸く
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${text[index]}",
                  style: GoogleFonts.shipporiMincho(
                    fontSize: 50,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: icons[index],
                  onTap: () {
                    switch (index) {
                      case 0:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectListPage()));
                      // アクション1
                        break;
                      case 1:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Analysis()));
                      // アクション2
                        break;
                      case 2:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChartPage()));
                      // アクション3
                        break;
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
