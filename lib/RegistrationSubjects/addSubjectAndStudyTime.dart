
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../StudiedTime/AddStudyTime.dart';
import 'AddSubjectNextPage.dart';
import '../View/AppBarBase.dart';
import '../main.dart';

class AddSubjectAndStudyTime extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
      // メイン画面に戻る
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
      return false; // バックナビゲーションをキャンセル
    },
    child:
      Scaffold(
      appBar: AppBarBase(title: "登録ページ",n:MyApp(),),

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.greenAccent[100],
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 30,),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.tealAccent[100],
                      borderRadius: BorderRadius.circular(14.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    height: 250,
                    width: 250,
                    padding: EdgeInsets.all(20.0),

                    child: Lottie.asset("assets/subjects.json"),
                  ),
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddSubjectNextPage()));
                  },
                ),


                Text("科目登録ボタン↑",style: GoogleFonts.shipporiMincho(fontSize:30,fontWeight: FontWeight.bold),),

                SizedBox(height: 10,),

                GestureDetector(
                  child: Container(
                    height: 250,
                    width: 250,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[200],
                      borderRadius: BorderRadius.circular(14.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Lottie.asset("assets/studytimes.json"),
                  ),
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddStudyTime()));
                  },
                ),

                Text("勉強時間＆休憩時間登録ボタン↑",style: GoogleFonts.shipporiMincho(fontSize: 23,fontWeight: FontWeight.bold),)
              ],
            )
        )
      )
    )
    );
  }

}