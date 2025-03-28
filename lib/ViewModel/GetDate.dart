
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Repo/DateDatabase.dart';
import '../Repo/DateReportDatabase.dart';

class GetDate extends ChangeNotifier {
  List<BarChartGroupData> barData = [];
  List<BarChartGroupData> barDataR = [];
  List<String> datesR = [];
  List<String> singleDatesR = [];
  List<String> singleDates = [];
  List<String> dates = [];
  

  getBarData()async{
    barData.clear();
    dates.clear();
    barDataR.clear();
    singleDatesR.clear();
    datesR.clear();

    DatabaseHelper db = DatabaseHelper();

    final data = await db.getDuplicateCounts();

    DatabaseHelperR dbR = DatabaseHelperR();

    final dataR = await dbR.getDuplicateCounts();

    if(dataR.isNotEmpty){
      for(int i = 0; i < dataR.length; i ++){
        datesR.add(dataR[i]["date"]);
        int count = dataR[i]["count"];
        barDataR.add(
            BarChartGroupData(x: i ,
                barRods: [BarChartRodData(toY: count.toDouble(),
                  color: Colors.blueAccent,width: 30,
                  borderRadius: BorderRadius.zero,)]));
      }
    }

    if(data.isNotEmpty){
      for(int i = 0; i < data.length; i ++){
        dates.add(data[i]["date"]);
        int count = data[i]["count"];

        print(count);


        barData.add(BarChartGroupData(
            x: i,barRods: [BarChartRodData(toY: count.toDouble(),color: Colors.yellowAccent,width: 30,borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        ))],barsSpace: 80));

      }
      print(dates);
    }
    

    notifyListeners();
  }

  getSingleBarData()async {
    singleDates.clear();
    singleDatesR.clear();

    DatabaseHelper db = DatabaseHelper();

    final data = await db.getNonDuplicates();

    DatabaseHelperR dbR = DatabaseHelperR();

    final dateR = await dbR.getNonDuplicates();

    if(dateR.isNotEmpty){
      for(int i = 0; i < dateR.length; i ++){
        singleDatesR.add(dateR[i]["date"]);
      }
    }

    if(data.isNotEmpty){
      for(int i = 0; i < data.length; i ++){
        singleDates.add(data[i]["date"]);
      }
    }

    print("$singleDates da-----------=====---===");

    notifyListeners();
  }
}