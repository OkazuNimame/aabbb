import 'package:aabbb/View/AppBarBase.dart';
import 'package:aabbb/View/ChartDeleteDialog.dart';
import 'package:aabbb/ViewModel/GetChartData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../View/NoDataPage.dart';
import '../main.dart';

class ChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChartPage();
  }
}

class _ChartPage extends State<ChartPage> {
  DatabaseReference db = FirebaseDatabase.instance.ref().child("times");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  loadData() async {
    await context.read<GetChartData>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = Provider.of<GetChartData>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ChartDeleteDialog delete = ChartDeleteDialog();
            delete.chartDelete(context, chartData).show();
          },
          child: Icon(Icons.delete_forever_outlined),
        ),
        appBar: AppBarBase(title: "チャートページ", n: MyApp()),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              chartData.studySpots.isNotEmpty || chartData.breakSpots.isNotEmpty
                  ? GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // 横スクロールの動作を追加する場合
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: chartData.studySpots.length * 100.0 ,  // スクロールの幅を調整
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            lineBarsData: [
                              LineChartBarData(
                                spots: chartData.studySpots, // studyTime のデータをセット
                                isCurved: false,
                                color: Colors.blue,
                                barWidth: 3,
                              ),
                              LineChartBarData(
                                spots: chartData.breakSpots, // breakTime のデータをセット
                                isCurved: false,
                                color: Colors.green,
                                barWidth: 3,
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true,interval: 1),

                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  interval: 1,
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    print("${value.toInt()}dal;gja;dlgjas;rlgajd;galkj:l");
                                    print("${chartData.date}");
                                    int index = value.toInt();  // インデックスとして使う
                                    if (index >= 0 && index < chartData.date.length) {
                                      return Container(
                                        padding: EdgeInsets.only(),
                                        child: Text("${chartData.date[index]}",style: TextStyle(fontSize: 13),),
                                      );
                                    } else {
                                      return SizedBox.shrink(); // 範囲外なら何も表示しない
                                    }
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(),
                              rightTitles: AxisTitles(),
                            ),
                            borderData: FlBorderData(show: true),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  : NoDataPage(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "グリーン",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "：休憩時間",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "ブルー",
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextSpan(
                      text: "：勉強時間",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
