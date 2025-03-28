import 'package:aabbb/StudiedTime/ChartPage.dart';
import 'package:aabbb/View/ShowDialog.dart';
import 'package:aabbb/ViewModel/GetChartData.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChartDeleteDialog {
  AwesomeDialog chartDelete(BuildContext context,GetChartData g){
    return AwesomeDialog(
      dialogType: DialogType.noHeader,
        customHeader: Lottie.asset("assets/delete.json",fit: BoxFit.cover),
        context: context,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Text("勉強時間"),

            Container(
              height: 300,
              width: MediaQuery.of(context).size.width * g.studyBars.length,



              child:g.studyBars.isNotEmpty?
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: 300,
                      width:g.breakTime.length <= 3?MediaQuery.of(context).size.width: g.breakTime.length * 120.0,
                      child:  BarChart(
                          BarChartData(
                              barGroups: g.studyBars,

                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        interval:g.study.any((e) => e >= 10)?3 :1
                                    )
                                ),

                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        interval: 1,
                                        showTitles: true,
                                        getTitlesWidget: (value,meta){
                                          return Text(g.date[value.toInt()]);
                                        }
                                    )
                                ),
                                rightTitles: AxisTitles(),

                              ),
                              barTouchData: BarTouchData(
                                touchCallback: (touchEvent, barTouchResponse) {
                                  if(touchEvent.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null){
                                    return ;
                                  }

                                  int touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;

                                  print("touchedIndex: $touchedIndex");

                                  DeleteCheckDialog(context: context, value: "${g.study[touchedIndex]}時間のデータを削除してよろしいですか？",ok: ()async{
                                    DatabaseReference db = FirebaseDatabase.instance.ref().child("times").child(g.id[touchedIndex]).child("breakTime");


                                    db.get().then((DataSnapshot snapshot)async {
                                      if (snapshot.exists) {
                                        // データが存在する場合
                                        print("データが存在します: ${snapshot.value}");

                                        print("${g.id[touchedIndex]}ですうううううううう");


                                        DatabaseReference db = FirebaseDatabase.instance.ref().child("times").child(g.id[touchedIndex]).child("studyTime");

                                        await db.remove();


                                      } else {
                                        // データが存在しない場合
                                        print("データが存在しません");

                                        DatabaseReference db = FirebaseDatabase.instance.ref().child("times").child(g.id[touchedIndex]);


                                        await db.remove();

                                      }
                                      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChartPage()));
                                    });
                                    Navigator.pop(context);
                                  }).deleteLog();
                                },)
                          )
                      )
                    )
                        ):Text("データがありません")
                  ),


            Text("休憩時間"),

            g.breakTime.isNotEmpty?

                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,

                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: 300,
                      width:g.studyBars.length <= 3?MediaQuery.of(context).size.width:  g.studyBars.length * 120.0,
                      child: BarChart(
                          BarChartData(
                              barGroups: g.breakBars,

                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        interval:g.study.any((e) => e >= 10)?3 :1
                                    )
                                ),

                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        interval: 1,
                                        showTitles: true,
                                        getTitlesWidget: (value,meta){
                                          return Text(g.date[value.toInt()]);
                                        }
                                    )
                                ),
                                rightTitles: AxisTitles(),

                              ),
                              barTouchData: BarTouchData(
                                  touchCallback: (touchEvent, barTouchResponse) {
                                    if(touchEvent.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null){
                                      return ;
                                    }

                                    int touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;

                                    print("touchedIndex: $touchedIndex");

                                    DeleteCheckDialog(context: context, value: "${g.breakTime[touchedIndex]}時間のデータをを削除してよろしいですか？",ok: (){
                                      DatabaseReference db = FirebaseDatabase.instance.ref().child("times").child(g.id[touchedIndex]).child("studyTime");

                                      db.get().then((DataSnapshot snap)async{
                                        if(snap.exists){
                                          print("データが存在します: ${snap.value}");

                                          DatabaseReference db = FirebaseDatabase.instance.ref().child("times").child(g.id[touchedIndex]).child("breakTime");

                                          await db.remove();

                                        }else{
                                          DatabaseReference db = FirebaseDatabase.instance.ref().child("times").child(g.id[touchedIndex]);

                                          await db.remove();


                                        }
                                        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChartPage()));
                                      });
                                    }).deleteLog();
                                  })
                          )
                      )
                    )
                  )
                ):Text("データがありません")


          ],
        ),
      )
    );
  }
}