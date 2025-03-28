import 'package:firebase_database/firebase_database.dart';

class SetSubject {
  final databaseRef = FirebaseDatabase.instance.ref(); // データベースのルート

  void addUser(String name, int classes, int reports, int timeLimit) {
    databaseRef.child("subjects").push().set({
      'name': name,
      'class': classes,
      'report': reports,
      'time_limit': timeLimit,
      'check':false
    });
  }

   addClassChecks(String id, int classes) async{
    List<Map<String, dynamic>> data = []; // リストでデータを作る
    
    for (int i = 0; i < classes; i++) {
      data.add({
        'id': i,
        'class': false,
        'date': "",
        'title': "",
        'value': "",
      });
    }
    await databaseRef.child("subjects").child(id).child("classChecks").runTransaction((current){
      if(current == null){
        return Transaction.success(data);
      }else{
        return Transaction.abort();
      }
    });
      
    
    // Firebaseにデータを追加
    
  }
  
  

   addReportChecks(String id,int reports) async{
    List<Map<String,dynamic>> data = [];

    for (int i = 0; i < reports; i++) {
      data.add({
        'id': i,
        'report':false,
        'date':"",
        'title':"",
        'value':"",
      });
    }
    
    await databaseRef.child("subjects").child(id).child("reportChecks").runTransaction((current){
      if(current == null){
        return Transaction.success(data);
      }else{
        return Transaction.abort();
      }
    });
    return data;
  }
}