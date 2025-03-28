import 'package:flutter/material.dart';

class TextFieldViewModel extends ChangeNotifier {
   TextEditingController textController = TextEditingController();
   TextEditingController class_Controller = TextEditingController();
   TextEditingController report_Controller = TextEditingController();
   TextEditingController timeLimit_Controller = TextEditingController();
   TextEditingController title_Controller = TextEditingController();
   TextEditingController value_Controller = TextEditingController();

  String get text => textController.text;

  String get class_ => class_Controller.text;

  String get report => report_Controller.text;

  String get timeLimit => timeLimit_Controller.text;

  bool check = false;

  void updateText(String newText) {
    textController.text = newText;
    notifyListeners();
  }

  void updateClass(String newText){
    class_Controller.text = newText;

    notifyListeners();
  }

  void updateReport(String newText){
    report_Controller.text = newText;
    notifyListeners();
  }

  void updateTimeLimit(String newText){
    timeLimit_Controller.text = newText;

    notifyListeners();
  }

  bool checkNumberText(TextEditingController c){

    if(c.text.isNotEmpty && int.parse(c.text) != 0){
      check = true;
      notifyListeners();
      return check;
    }else{
      check = false;
      notifyListeners();
      return check;
    }
  }

  bool checkStringText(TextEditingController c){

    if(c.text.isNotEmpty && c.text != ""){
      check = true;
      notifyListeners();
      return check;
    }else{
      check = false;
      notifyListeners();
      return check;
    }
  }

  bool inputCheck(){
    if(text.isNotEmpty && class_.isNotEmpty &&
        int.parse(class_) != 0 && report.isNotEmpty &&
        int.parse(report) != 0 && timeLimit.isNotEmpty && int.parse(timeLimit) != 0){

      return true;
    }else{

      return false;
    }
  }


    dis(){
     textController = TextEditingController();
     class_Controller = TextEditingController();
     report_Controller = TextEditingController();
     timeLimit_Controller = TextEditingController();
     title_Controller = TextEditingController();
     value_Controller = TextEditingController();
     notifyListeners();
   }


}
