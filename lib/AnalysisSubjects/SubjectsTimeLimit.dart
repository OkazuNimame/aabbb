
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../View/AppBarBase.dart';
import '../View/NoDataPage.dart';
import '../ViewModel/GetTimeLimit.dart';
import 'TimeLimitPage.dart';
import 'analysis.dart';

class SubjectsTimeList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SubjectsTimeList();
  }

}

class _SubjectsTimeList extends State<SubjectsTimeList>{


  @override
  Widget build(BuildContext context) {
    
    final getData = Provider.of<GetTimeLimit>(context);

    final DatabaseReference _databaseRef =
    FirebaseDatabase.instance.ref().child("subjects"); // "users" ノードを指定
    return WillPopScope(
        child: Scaffold(
          appBar: AppBarBase(title: "単位取得不可までのコマ数",n: Analysis(),),

          body: StreamBuilder(
            stream: _databaseRef.onValue, // 🔥 データが更新されたら自動取得
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return Center(child: NoDataPage());
              }

              // Firebaseから取得したデータを Map に変換
              Map<dynamic, dynamic> users =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

              List<Map<String, dynamic>> userList = [];
              users.forEach((key, value) {
                userList.add({"id": key, "name": value["name"], "class": value["class"],"report":value["report"],"check":value["check"],"timeLimit":value["time_limit"]});
              });

              return userList.isNotEmpty? ListView.builder(

                itemCount: userList.length,
                itemBuilder: (context, index) {
                  print(userList);
                  return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                          title:userList[index]["check"]?
                          Text("${userList[index]["name"]} 完了！",style: GoogleFonts.hinaMincho(fontSize: 30,color: Colors.red),):
                          Text(userList[index]["name"],style: GoogleFonts.hinaMincho(fontSize: 30,),),

                          subtitle:getData.checkList >= userList[index]["timeLimit"]?Text("もう単位取得不可です！",style: GoogleFonts.hinaMincho(fontSize: 18,color: Colors.red),): Text("単位取得不可までのコマ数${userList[index]["timeLimit"]}",style: GoogleFonts.hinaMincho(fontSize: 18)),

                          onTap: ()async{

                            if(userList[index]["check"]){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('もう完了しています！'),
                                  ),);
                            }else{
                              DatabaseReference db = FirebaseDatabase.instance.ref().child("subjects").child(userList[index]["id"]).child("timeLimitChecks");
                              final snapshot = await db.get();

                              if(snapshot.exists){

                              }else{
                                Map<String, dynamic> timeLimitData = {};

                                for (int i = 0; i < userList[index]["timeLimit"]; i++) {
                                  timeLimitData["check$i"] = false;
                                }

// すべてのデータを一括で Firebase に保存
                                await db.set(timeLimitData);
                              }


                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TimeLimitPage(name: userList[index]["name"],id: userList[index]["id"],)));
                            }



                          }
                      )
                  );
                },
              ):NoDataPage();
            },
          ),
        ),



        onWillPop: ()async{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Analysis()));
          return false;
        });
  }

}