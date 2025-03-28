import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GetChartData extends ChangeNotifier {
  DatabaseReference db = FirebaseDatabase.instance.ref().child("times");

  List<FlSpot> studySpots = [];
  List<FlSpot> breakSpots = [];
  List<BarChartGroupData> studyBars = [];
  List<BarChartGroupData> breakBars = [];
  List<String>date = [];
  List<int> study = [],breakTime = [];

  List<String> id = [];
  List<Map<String, dynamic>> userList = [];

  double minX = 0;
  double maxX = 5; // 初期表示は5点分

  Future<void> getData() async {
    userList.clear();
    studySpots.clear();
    breakSpots.clear();
    studyBars.clear();
    breakBars.clear();
    date.clear();
    study.clear();
    breakTime.clear();
    id.clear();
    notifyListeners();
    try {
      DatabaseEvent event = await db.once();
      DataSnapshot snapshot = event.snapshot;

      if (!snapshot.exists || snapshot.value == null) {
        print("⚠ データがありません");
        return;
      }

      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      print("$dataあああああああ");


      data.forEach((key, value) {
        // 'breakTime'、'studyTime'、'date' のいずれかが null でない場合にリストに追加
        Map<String, dynamic> item = {"id": key};  // idを最初に追加

        // nullの場合は0を代入
        value["breakTime"] != null?
        item["breakTime"] = value["breakTime"]:item["breakTime"] = null;
        value["studyTime"] != null?
        item["studyTime"] = value["studyTime"]:item["studyTime"] = null;
        value["date"] != null?
        item["date"] = value["date"]:item["date"] = null;

        // リストに追加
        userList.add(item);
      });


      print("${userList}apogjagj;gljka;glkjadsg;ajg;alkjgal;djkg;lakdjg;alkj");




      // X 軸を等間隔にする（例：1刻み）
      for (int i = 0; i < userList.length; i++) {


        userList[i]["studyTime"] != null? studyBars.add(BarChartGroupData(x: i,barRods: [BarChartRodData(toY: userList[i]["studyTime"].toDouble(),width: 30,color: Colors.blue,borderRadius: BorderRadius.zero)])):null;
        userList[i]["studyTime"] != null? studySpots.add(FlSpot(i.toDouble(), userList[i]["studyTime"].toDouble())):null;

        userList[i]["studyTime"] != null? study.add(userList[i]["studyTime"]):null;


        userList[i]["breakTime"] != null?  breakBars.add(BarChartGroupData(x: i,barRods: [BarChartRodData(toY:userList[i]["breakTime"].toDouble(),width: 30,color: Colors.green,borderRadius: BorderRadius.zero)])):null;
        userList[i]["breakTime"] != null? breakSpots.add(FlSpot(i.toDouble(), userList[i]["breakTime"].toDouble())):null;
        userList[i]["breakTime"] != null? breakTime.add(userList[i]["breakTime"]):null;



         userList[i]["date"] != null? date.add(userList[i]["date"]):null;
         userList[i]["id"] != null? id.add(userList[i]["id"]):null;








        notifyListeners();

        print("${userList[i]["studyTime"]}desuwayo~~~~~~~");
        print("${userList[i]["breakTime"]}~~~~~~~~~~~~~~~~~~~~~~");
        print("${id}==============================~~~~~~~~~~~~~~~~~~~|||||||||||||||");
      }

      // スクロール可能にするため maxX をデータ数に合わせる
      maxX = studySpots.length > 5 ? studySpots.length.toDouble() : 5;

      notifyListeners();
    } catch (e) {
      print("🔥 データ取得エラー: $e");
    }
  }
}
