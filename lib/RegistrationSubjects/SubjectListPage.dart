
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Repo/DateDatabase.dart';
import '../Repo/DateReportDatabase.dart';
import '../View/AppBarBase.dart';
import '../View/NoDataPage.dart';
import '../View/ShowDialog.dart';
import '../ViewModel/GetClassValue.dart';
import '../ViewModel/GetDate.dart';
import '../ViewModel/GetSubjectsData.dart';
import '../ViewModel/SetSubject.dart';
import '../main.dart';
import 'ClassReportSavePage.dart';

class SubjectListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubjectListPage();
  }
}

class _SubjectListPage extends State<SubjectListPage> {
  bool deleteCheck = false;
  List<bool> checkList = [];
  List<int> deleteIds = [];


  @override
  void initState() {
    super.initState();
    loadData();

  }

  loadData() async {
    await context.read<GetSubjectsData>().getData();
    await context.read<GetDate>().getBarData();
    await context.read<GetDate>().getSingleBarData();
  }







  @override
  Widget build(BuildContext context) {
    final getBool = Provider.of<GetClassValue>(context);
    print("${getBool.allClassTrue}だーーーーーーーー！！！");
    print("${getBool.allReportTrue}だーーーーー！！");


    final get = Provider.of<GetSubjectsData>(context);
    final dateData = Provider.of<GetDate>(context);
    //final class_reportData = Provider.of<GetClassAndReportData>(context);

    final DatabaseReference _databaseRef =
    FirebaseDatabase.instance.ref().child("subjects"); // "users" ノードを指定



    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        setState(() {
          deleteCheck = false;
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBarBase(title: "登録科目一覧",n: MyApp(),),
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
              userList.add({"id": key, "name": value["name"], "class": value["class"],"report":value["report"],"check":value["check"]});
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

                    subtitle: Text("授業数: ${userList[index]["class"]}, レポート数: ${userList[index]["report"]}",style: GoogleFonts.hinaMincho(fontSize: 18)),

                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DeleteCheckDialog delete = DeleteCheckDialog(ok: ()async{

                          DatabaseHelper db = DatabaseHelper();
                          DatabaseHelperR dbR = DatabaseHelperR();

                          if(dateData.barData.isNotEmpty){
                            await db.allDelete(userList[index]["id"]);

                           // await dbR.deleteUser(userList[index]["id"]);
                          }

                          if(dateData.barDataR.isNotEmpty){
                            await dbR.allDelete(userList[index]["id"]);
                          }



                          get.deleteData(userList[index]["id"]);
                        },value: "${userList[index]["name"]}を削除してもよろしいですか？",context: context);
                        getBool.allClassTrue.clear();
                        getBool.allReportTrue.clear();
                        delete.deleteLog();
                      }, // 削除ボタン
                    ),
                    onTap: ()async{
                      //get.getStudyData(userList[index]["id"]);
                      SetSubject set = SetSubject();
                      set.addClassChecks(userList[index]["id"].toString(), userList[index]["class"]);
                      set.addReportChecks(userList[index]["id"].toString(), userList[index]["report"]);

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassReportSavePage(
                        id: userList[index]["id"].toString(),
                        subject_name: userList[index]["name"],
                        classes: userList[index]["class"],reports: userList[index]["report"],)));

                    }
                  )
                );
              },
            ):NoDataPage();
          },
        ),
      )
    );
  }
}
