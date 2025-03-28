

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../View/AppBarBase.dart';
import '../ViewModel/GetDate.dart';
import '../main.dart';
import 'SubjectsTimeLimit.dart';

class Analysis extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Analysis();
  }
}

class _Analysis extends State<Analysis> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await context.read<GetDate>().getBarData();
    await context.read<GetDate>().getSingleBarData();
  }

  @override
  Widget build(BuildContext context) {
    final barData = Provider.of<GetDate>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectsTimeList()));
        },child: Icon(Icons.next_plan_outlined),),
        appBar: AppBarBase(title: "分析ページ", n: MyApp()),
        body: SingleChildScrollView(
          child:  Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15,),

              Text("複数回授業を受けた日",style: GoogleFonts.sawarabiMincho(fontSize: 25),),
              // グラフの表示部分
              barData.barData.isNotEmpty && barData.dates.isNotEmpty
                  ?SizedBox(
                height: 300,
                width: barData.barData.length * 500,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,  // 幅を制限
                    ),
                    child: BarChart(
                      BarChartData(
                        barGroups: barData.barData,
                        backgroundColor: Colors.blueGrey[100],
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, interval: 1),
                          ),
                          rightTitles: AxisTitles(),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                return Text(barData.dates[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  : Center(child: Text("データがありません")),
              SizedBox(height: 20),

              // タイトル部分
              Text(
                "一回しか授業を受けていない日",
                style: GoogleFonts.sawarabiMincho(fontSize: 25),
                overflow: TextOverflow.ellipsis,
              ),

              // SingleDatesのリスト
              barData.singleDates.isNotEmpty
                  ? Container( // Expandedを使って、ListViewに空きスペースを与える
                height: 300,
                width: MediaQuery.of(context).size.width * 300,
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: barData.singleDates.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlueAccent,
                      ),
                      child: Center(

                          child:  ListTile(
                            title: Text(barData.singleDates[index]),
                            leading: Icon(Icons.analytics_outlined),
                          ),
                        )
                      );
                  },
                ),
              )
                  : Center(child: Text("授業データがありません")), // データがない場合のメッセージ


              SizedBox(height: 15,),

              Text("複数レポートをした日",style: GoogleFonts.sawarabiMincho(fontSize: 25),),

          SizedBox(height: 5,),
          barData.barDataR.isNotEmpty && barData.datesR.isNotEmpty
              ? SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width, // 画面幅いっぱい
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 横スクロール可能にする
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: barData.barData.length * 500, // バーの数に応じた幅
                ),
                child: BarChart(
                  BarChartData(
                    groupsSpace: 80, // バーの間隔を一定に
                    barGroups: barData.barDataR,
                    backgroundColor: Colors.blueGrey[100],
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 1),
                      ),
                      rightTitles: AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < barData.datesR.length) {
                              return Text(barData.datesR[index]);
                            }
                            return Text("");
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
              : Center(child: Text("レポートデータがありません")),


          SizedBox(height: 20,),

              Text("一枚しかやらなかった日",style: GoogleFonts.sawarabiMincho(fontSize: 25),),

              barData.singleDatesR.isNotEmpty
                  ? Container( // Expandedを使って、ListViewに空きスペースを与える
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: barData.singleDatesR.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlueAccent,
                        ),
                        child: Center(

                          child:  ListTile(
                            title: Text(barData.singleDatesR[index]),
                            leading: Icon(Icons.analytics_outlined),
                          ),
                        )
                    );
                  },
                ),
              )
                  : Center(child: Text("レポートデータがありません")),
            ],
          ),
        )
        ),
    );
  }
}
