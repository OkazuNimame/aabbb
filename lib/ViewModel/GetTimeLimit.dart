import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

class GetTimeLimit extends ChangeNotifier {


  int checkList = 0;

  void setData(int checks,String id)async{
    DatabaseReference db = FirebaseDatabase.instance.ref().child("subjects").child(id).child("timeLimitChecks");

    DataSnapshot data = await db.get();

    Map<dynamic, dynamic> rawData = data.value as Map<dynamic, dynamic>;

    print(rawData);

    int trueCount = rawData.values.where((value) => value).length;

    checkList = trueCount;

    notifyListeners();

    print(checkList);



  }

}