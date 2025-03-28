
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Repo/DateDatabase.dart';
import '../Repo/DateReportDatabase.dart';
import '../View/AppBarBase.dart';
import '../View/ShowDialog.dart';
import '../ViewModel/GetClassValue.dart';
import 'ClassReportDataPage.dart';
import 'SubjectListPage.dart';
import 'addSubjectReportData.dart';

class ClassReportSavePage extends StatefulWidget {
  final String subject_name;
  final String id;
  final int classes;
  final int reports;

  ClassReportSavePage({required this.id, required this.subject_name,required this.classes,required this.reports});

  @override
  State<StatefulWidget> createState() {
    return _ClassReportSavePage();
  }
}

class _ClassReportSavePage extends State<ClassReportSavePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  

  loadData()async{
    await context.read<GetClassValue>().fetchData(widget.id, widget.classes);
    await context.read<GetClassValue>().fetchReportData(widget.id, widget.reports);

    bool allClass = context.read<GetClassValue>().allClassTrue.every((_element) => _element == true);

    bool allReport = context.read<GetClassValue>().allReportTrue.every((_element) => _element == true);

    if(allClass && allReport){
      final DatabaseReference database = FirebaseDatabase.instance.ref().child("subjects").child(widget.id);

      database.update({
        "check":true,
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final getBool = Provider.of<GetClassValue>(context);

    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("classChecks");

    final DatabaseReference databaseReport =
    FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("reportChecks");

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectListPage()));
        return false;
      },
      child: Scaffold(
        appBar: AppBarBase(title: "${widget.subject_name}の進捗", n: SubjectListPage()),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // クラスの進捗データを表示
            Center(
              child: StreamBuilder(
                stream: databaseRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return Center(child: Text("データがありません"));
                  }

                  var data = snapshot.data!.snapshot.value;
                  print("back data is $data");

                  List<dynamic> datas = (data as List<dynamic>? ?? []);
                  List<Map<String, dynamic>> dataList = datas
                      .where((item) => item != null && item is Map)
                      .map((item) => Map<String, dynamic>.from(item as Map))
                      .toList();

                  return Container( // ここで Expanded を使って ListView のサイズを調整
                    height: 150,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> newData = dataList[index];
                        return Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange, Colors.amberAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: EdgeInsets.only(left: 15),
                            child: newData["class"]
                                ? Center(
                                child: ListTile(
                                  title: Text(
                                    "${widget.subject_name} ${index + 1}コマ目:完了！",
                                    style: GoogleFonts.bizUDPMincho(color: Colors.red,fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text("${newData["date"]}", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15),),
                                  titleAlignment: ListTileTitleAlignment.center,
                                  onTap: () {
                                    final DatabaseReference database =
                                    FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("classChecks").child(index.toString());
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassReportStudy(
                                      databaseReference: database,
                                      id: widget.id, subject_name: widget.subject_name,
                                      classes: widget.classes, reports: widget.reports,
                                      index:  index,
                                    )));
                                  },
                                  leading: IconButton(
                                    onPressed: ()async {
                                      final DatabaseReference database =
                                      FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("classChecks").child(index.toString());

                                      final DatabaseReference checkData = FirebaseDatabase.instance.ref().child("subjects").child(widget.id);

                                      await checkData.update({
                                        "check":false
                                      });

                                      DeleteCheckDialog delete = DeleteCheckDialog(ok: () async {
                                        database.set({
                                          "class": false,
                                          "date": "",
                                          "id": index,
                                          "title": "",
                                          "value": ""
                                        });

                                        DatabaseHelper db = DatabaseHelper();

                                        await db.deleteUser(widget.id,index.toString());
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassReportSavePage(id: widget.id, subject_name: widget.subject_name, classes: widget.classes, reports: widget.reports)));

                                      }, value: "この授業の進捗内容を削除してもよろしいですか？", context: context);


                                      await delete.deleteLog();

                                      print("${getBool.allClassTrue}ですううーーーーー！！！");
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                )
                            )
                                : Center(
                              child: ListTile(
                                title: Text("${widget.subject_name}:${index + 1}コマ目", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20),),
                                subtitle: ElevatedButton(onPressed: () {
                                  final DatabaseReference database =
                                  FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("classChecks").child(index.toString());

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassReportStudy(
                                    databaseReference: database,
                                    id: widget.id, subject_name: widget.subject_name,
                                    classes: widget.classes, reports: widget.reports,
                                    index: index,
                                  )));
                                }, child: Text("未完了")),
                                titleAlignment: ListTileTitleAlignment.center,
                              ),
                            )
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 29),
            // レポートの進捗データを表示
            Center(
              child: StreamBuilder(
                stream: databaseReport.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return Center(child: Text("データがありません"));
                  }

                  var data = snapshot.data!.snapshot.value;
                  print("back data is $data");

                  List<dynamic> datas = (data as List<dynamic>? ?? []);
                  List<Map<String, dynamic>> dataList = datas
                      .where((item) => item != null && item is Map)
                      .map((item) => Map<String, dynamic>.from(item as Map))
                      .toList();

                  return Container( // ここでも Expanded を使う
                    height: 150,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> newData = dataList[index];
                        return Container(
                            width: 300,
                            height: 312,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.lightBlueAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: EdgeInsets.only(left: 15),
                            child: newData["report"]
                                ? Center(
                                child: ListTile(
                                  title: Text(
                                    "${widget.subject_name} ${index + 1}枚目:完了！",
                                    style: GoogleFonts.bizUDPMincho(color: Colors.red,fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text("${newData["date"]}", overflow: TextOverflow.ellipsis),
                                  onTap: () {
                                    final DatabaseReference database =
                                    FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("reportChecks").child(index.toString());

                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassReportStudy(
                                      databaseReference: database,
                                      id: widget.id, subject_name: widget.subject_name,
                                      classes: widget.classes, reports: widget.reports,
                                      index: index,
                                    )));
                                  },
                                  leading: IconButton(
                                    onPressed: ()async {
                                      final DatabaseReference database =
                                      FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("reportChecks").child(index.toString());
                                      final DatabaseReference checkData = FirebaseDatabase.instance.ref().child("subjects").child(widget.id);

                                      await checkData.update({
                                        "check":false
                                      });
                                      DeleteCheckDialog delete = DeleteCheckDialog(ok: () async{
                                        database.set({
                                          "report": false,
                                          "date": "",
                                          "id": index,
                                          "title": "",
                                          "value": ""
                                        });
                                        DatabaseHelperR db = DatabaseHelperR();

                                        await db.deleteUser(widget.id,index.toString());

                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassReportSavePage(id: widget.id, subject_name: widget.subject_name, classes: widget.classes, reports: widget.reports)));
                                      }, value: "このレポートの進捗内容を削除してもよろしいですか？", context: context);
                                       delete.deleteLog();
                                       
                                       print("${getBool.allReportTrue}でしいた＝＝＝＝＝＝＝ーーー！！");

                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                )
                            )
                                :Center(
                              child:  ListTile(
                                title: Text("${widget.subject_name}:${index + 1}枚目", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20),),
                                subtitle: ElevatedButton(onPressed: () {
                                  final DatabaseReference database =
                                  FirebaseDatabase.instance.ref().child("subjects").child(widget.id).child("reportChecks").child(index.toString());

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddSubjectReportData(
                                    databaseReference: database,
                                    id: widget.id, subject_name: widget.subject_name,
                                    classes: widget.classes, reports: widget.reports,
                                    index: index,
                                  )));
                                }, child: Text("未完了")),
                                titleAlignment: ListTileTitleAlignment.center,
                              ),
                            )
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
