import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../Repo/DateDatabase.dart' show DatabaseHelper;
import '../View/AppBarBase.dart';
import '../View/NoDataPage.dart';
import '../View/TextFieldView.dart';
import '../ViewModel/TextFieldViewModel.dart';
import 'ClassReportSavePage.dart';
import 'SubjectListPage.dart';

class ClassReportStudy extends StatefulWidget {
  DatabaseReference databaseReference;
  String id;
  String subject_name;
  int classes;
  int index;
  int reports;

  ClassReportStudy({required this.databaseReference, required this.id, required this.subject_name,required this.classes,required this.reports,required this.index});

  @override
  State<StatefulWidget> createState() {
    return _ClassReportStudy();
  }
}

class _ClassReportStudy extends State<ClassReportStudy> {
  DateTime? selectDate;
  bool isInitialized = false; // データ初期化チェック用

  Future<void> _selectTime(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectDate = picked; // `selectDate` のみ更新（テキストリセットを防ぐ）
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textView = Provider.of<TextFieldViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectListPage()));
        return false;
      },
      child: Scaffold(
        appBar: AppBarBase(title: "内容記録ページ", n: SubjectListPage()),

        body: StreamBuilder(
          stream: widget.databaseReference.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return NoDataPage();
            }

            var data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            print("back data is $data");

            Map<String, dynamic> listData = data.cast<String, dynamic>();

            print(listData);

            String date = listData["date"] ?? "";
            String title = listData["title"] ?? "";
            String value = listData["value"] ?? "";

            if (!isInitialized) {
              // 初回のみデータをセット（再ビルド時にリセットされるのを防ぐ）
              selectDate = (date.isNotEmpty && date != "null") ? DateFormat("yyyy/MM/dd").parse(date) : null;
              textView.title_Controller.text = title;
              textView.value_Controller.text = value;
              isInitialized = true;
            }

            print("$title です！！");

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _selectTime(context);
                      },
                      child: selectDate != null
                          ? Text(DateFormat("yyyy/MM/dd").format(selectDate!))
                          : Text("日付を選択"),
                    ),

                    SizedBox(height: 15),

                    TextFieldView(
                      controller: textView.title_Controller,
                      labelText: "授業タイトル",
                      hintText: "例：〜の授業",
                      textInputType: TextInputType.multiline,
                      maxLines: null,
                      on: textView.title_Controller.text == ""? true:false,
                    ),

                    SizedBox(height: 10),

                    TextFieldView(
                      controller: textView.value_Controller,
                      labelText: "振り返り",
                      hintText: "例：〜のやり方がわかった！",
                      textInputType: TextInputType.multiline,
                      maxLines: null,
                      on:textView.value_Controller.text == ""? true:false,
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        if (selectDate == null) {
                          print("❌ 日付が選択されていません");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("日付を入力してください！"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        String formattedDate = DateFormat("yyyy/MM/dd").format(selectDate!);
                        print("✅ 保存する日付: $formattedDate");

                        await widget.databaseReference.update({
                          "date": formattedDate, // ここを修正
                          "title": textView.title_Controller.text,
                          "value": textView.value_Controller.text,
                          "class": true,
                        });

                        DatabaseHelper db = DatabaseHelper();

                        await db.insertOrUpdateUser({
                          "dateId":widget.id.isNotEmpty?widget.id:"",
                          "date":formattedDate.isNotEmpty?formattedDate:"",
                          "dateSubId":widget.index.toString()
                        }, widget.id,widget.index.toString());
                        print(widget.index);
                        textView.dis();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassReportSavePage(
                              id: widget.id,
                              subject_name: widget.subject_name,
                              classes: widget.classes,
                              reports: widget.reports,
                            ),
                          ),
                        );
                      },
                      child: Lottie.asset("assets/save.json"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
