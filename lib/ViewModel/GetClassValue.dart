import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class GetClassValue extends ChangeNotifier {
  List<bool> allClassTrue = []; // 判定結果を保持
  List<bool> allReportTrue = [];
  bool isLoading2 = true;
  bool isLoading = true; // ロード中フラグ

  /// Firebase からデータを 1 回だけ取得して判定
  Future<void> fetchData(String id, int classes) async {
    isLoading = true;
    allClassTrue.clear(); // データ取得前にリストをクリア

    // 並列処理でデータ取得
    List<bool> futures = [];

    for (int i = 0; i < classes; i++) {
      futures.add(await _fetchClassCheck(id, i));
    }

    allClassTrue = futures;

    print("$allClassTrueですぞ〜〜〜〜〜！！");

    isLoading = false;
    notifyListeners(); // まとめて更新通知
  }

  Future<void> fetchReportData(String id, int reports) async {
    isLoading2 = true;
    allReportTrue.clear(); // データ取得前にリストをクリア

    List<bool> futures = [];

    for (int i = 0; i < reports; i++) {
      futures.add(await _fetchReportCheck(id, i));

    }

    allReportTrue = futures;

    print(allReportTrue);

    isLoading2 = false;
    notifyListeners(); // まとめて更新通知
  }

  Future<bool> _fetchReportCheck(String id, int index) async {
    final DatabaseReference databaseRef = FirebaseDatabase.instance
        .ref()
        .child("subjects")
        .child(id)
        .child("reportChecks").child(index.toString());

    final snapshot = await databaseRef.once();

    if (snapshot.snapshot.value != null) {
      var data = snapshot.snapshot.value as Map<dynamic, dynamic>;


        // `data` が Map の場合
        Map<String, dynamic> newData = Map<String, dynamic>.from(data);

        return _isAllReportChecksTrue(newData);

    }

    return false;
  }


  /// 各 classCheck のデータを取得して `class` の判定を行う
  Future<bool> _fetchClassCheck(String id, int index) async {
    final DatabaseReference databaseRef = FirebaseDatabase.instance
        .ref()
        .child("subjects")
        .child(id)
        .child("classChecks")
        .child(index.toString());

    final snapshot = await databaseRef.once();

    if (snapshot.snapshot.value != null) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

      Map<String,dynamic> newData = (snapshot.snapshot.value as Map).cast<String,dynamic>();



      print("$dataだよ〜〜〜〜〜〜〜〜！！！");
      print(_isAllClassChecksTrue(newData));
      return _isAllClassChecksTrue(newData);
    }

    print("data is null");

    return false; // データがない場合は `false`
  }

  bool _isAllReportChecksTrue(Map<String, dynamic> data) {
    return data["report"] == true? true:false;
  }

  /// `classChecks` 内のすべての `class` が `true` なら `true` を返す
  bool _isAllClassChecksTrue(Map<String, dynamic> data) {
    return data["class"] == true? true:false;
  }
}
