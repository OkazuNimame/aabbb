
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../View/AppBarBase.dart';
import '../View/TextFieldView.dart';
import '../main.dart';

class AddStudyTime extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddStudyTime();
  }

}

class _AddStudyTime extends State<AddStudyTime> {
  TextEditingController studyTime = TextEditingController();
  TextEditingController breakTime = TextEditingController();

  DateTime? selectedDate;


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      print("選択された日付: ${picked.toLocal()}");
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(

          appBar: AppBarBase(title: "勉強時間記録ページ",n: MyApp(),),

          body: Center(
            child: Container(
              color: Colors.green[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue[300]
                    ),

                    child: ElevatedButton(onPressed: ()async{
                    await _selectDate(context);
                  },child: Text(selectedDate != null?"${DateFormat("yyyy/MM/dd").format(selectedDate!)}":"日付を選択してください"),),
                  ),


                  SizedBox(height: 30,),

                  Container(
                    padding: EdgeInsets.all(20),

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[100]
                    ),

                    child:TextFieldView(controller: studyTime, labelText: "勉強時間", hintText: "例：４", textInputType: TextInputType.number),
                  ),



                  SizedBox(height: 20,),

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[100]
                    ),

                    child:TextFieldView(controller: breakTime, labelText: "休憩時間", hintText: "例：３", textInputType: TextInputType.number),

                  ),


                  SizedBox(height: 30,),

                  ElevatedButton(onPressed: ()async{
                    DatabaseReference db = FirebaseDatabase.instance.ref().child("times");

                    if(studyTime.text.isNotEmpty && breakTime.text.isNotEmpty && selectedDate != null && studyTime.text != 0 && breakTime.text != 0){
                      await db.push().set({
                        "studyTime":int.parse(studyTime.text),
                        "breakTime":int.parse(breakTime.text),
                        "date":DateFormat("yyyy/MM/dd").format(selectedDate!)
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('値が入力されていません,または0が入力されました'),
                        ),
                      );

                    }

                  },child: Lottie.asset("assets/save.json"),)

                ],
              ),
            )
          )

        ),
        onWillPop: ()async{

          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyApp()));
          return false;
        });
  }

}