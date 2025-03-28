import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import '../Logic/Todo.dart';

class GetSubjectsData extends ChangeNotifier {
  Map<String,dynamic> data = {};
  Map<String,dynamic> studyData = {};

   getData() async {
     final databaseRef = FirebaseDatabase.instance.ref(); // データベースのルート
    await databaseRef.child("subjects").onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      print("Updated data: ${snapshot.value}");

      if (snapshot.value == null) {
        data = {};
        notifyListeners();
      }else{
        data = (snapshot.value as Map).cast<String, dynamic>();
        notifyListeners();
      }
      
    });
  }
  
  getStudyData(String id)async{
     final databaseRef = FirebaseDatabase.instance.ref(); // データベースのルート
    
    await databaseRef.child("subjects").child(id).child("classChecks").onValue.listen((DatabaseEvent event){
      DataSnapshot snapshot = event.snapshot;
      print("Updated data: ${snapshot.value}");

      if(snapshot.value != null){
        studyData = (snapshot.value as Map).cast<String,dynamic>();
        notifyListeners();
      }else{
        studyData = {};
        notifyListeners();
      }
    });
  }

   deleteData(String id)async {
     final databaseRef = FirebaseDatabase.instance.ref().child("subjects"); // データベースのルート
     databaseRef.child(id).remove().then((_) {
       print("Deleted User ID: $id");
     }).catchError((error) {
       print("Failed to delete user: $error");
     });

  }

}
