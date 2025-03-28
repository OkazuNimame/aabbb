
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../View/AppBarBase.dart';
import '../ViewModel/GetTimeLimit.dart';
import 'SubjectsTimeLimit.dart';
import 'analysis.dart';

class TimeLimitPage extends StatefulWidget {
  final String name;
  final String id;

  TimeLimitPage({required this.name, required this.id});

  @override
  State<StatefulWidget> createState() => _TimeLimitPage();
}

class _TimeLimitPage extends State<TimeLimitPage> {
  late DatabaseReference db;

  @override
  void initState() {
    super.initState();
    db = FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("timeLimitChecks");
  }

  @override
  Widget build(BuildContext context) {
    final setData = Provider.of<GetTimeLimit>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectsTimeList()));
        return false;
      },
      child: Scaffold(
        appBar: AppBarBase(title: "${widget.name}のタイムリミット", n: SubjectsTimeList()),
        body: StreamBuilder<DatabaseEvent>(
          stream: db.onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(child: Text("データがありません"));
            }

            Map<dynamic, dynamic> rawData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

// キーを String に変換してリストに格納
            List<Map<String, dynamic>> checkList = rawData.entries.map((entry) {
              return {entry.key.toString(): entry.value}; // キーを String に変換
            }).toList();


            int trueCount = checkList.where((map) => map.values.first == true).length;

            return Center(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: checkList.length,
                      itemBuilder: (context, index) {
                        String key = checkList[index].keys.first;
                        bool isChecked = checkList[index][key] == true;

                        return Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 200,
                                width: 200,
                                margin: EdgeInsets.only(left: 20,top: 30),
                                decoration: BoxDecoration(
                                  color: isChecked ? Colors.greenAccent : Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: isChecked
                                    ? Lottie.asset("assets/check.json")
                                    : Center(child: Text("${index + 1} コマ", style: TextStyle(fontSize: 20))),
                              ),
                              onTap: ()async {
                                setState(() {
                                  checkList[index][key] = !isChecked;


                                });
                                await db.child(key).set(checkList[index][key]);
                              },
                            ),

                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {

                      int trueCount = checkList.where((map) => map.values.first == true).length;

                      setData.setData(trueCount,widget.id);

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Analysis()));
                    },
                    child: Lottie.asset("assets/save.json"),
                  ),
                  Text("$trueCount / ${checkList.length}", style: GoogleFonts.bizUDMincho(fontSize: 30)),

                ],
              )
            );
          },
        ),
      ),
    );
  }
}
