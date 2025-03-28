
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../View/AppBarBase.dart';
import '../View/Button.dart';
import '../View/ShowDialog.dart';
import '../View/TextFieldView.dart';
import '../View/backgroundColor.dart';
import '../ViewModel/SetSubject.dart';
import '../ViewModel/TextFieldViewModel.dart';
import '../main.dart';

class AddSubjectNextPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final textViewModel = Provider.of<TextFieldViewModel>(context,listen: false);



    return WillPopScope(
        onWillPop: () async {
      // メイン画面に戻る

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
      textViewModel.dis();
      return false; // バックナビゲーションをキャンセル
    },child: Scaffold(
      appBar: AppBarBase(title: "科目情報登録ページ",n: MyApp(),v: (){
        textViewModel.dis();
      }),
      backgroundColor: Colors.yellow[100],
      body:Center(
        child:  SingleChildScrollView(

          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BackGroundColor(
                color: Colors.orange.shade100,
                child: TextFieldView(controller: textViewModel.textController,labelText: "科目名",hintText: "例：国語",textInputType: TextInputType.text,on: true,),
              ),

              SizedBox(height: 15,),

              BackGroundColor(
                color: Colors.orange.shade100,
                child:TextFieldView(controller: textViewModel.class_Controller,labelText: "授業数",hintText: "例：5 ※0は無効です",textInputType: TextInputType.number,v: FilteringTextInputFormatter.digitsOnly,on: true,),

              ),


              SizedBox(height: 15,),

              BackGroundColor(
                color: Colors.orange.shade100,
                child:TextFieldView(controller: textViewModel.report_Controller, labelText: "レポート数", hintText: "例：7 ※0は無効です", textInputType: TextInputType.number,v: FilteringTextInputFormatter.digitsOnly,on: true,),

              ),

              SizedBox(height: 15,),

              BackGroundColor(
                color: Colors.orange.shade100,
                child:TextFieldView(controller: textViewModel.timeLimit_Controller, labelText: "単位取得不可までのコマ数", hintText: "例：12 ※0は無効です", textInputType: TextInputType.number,v: FilteringTextInputFormatter.digitsOnly,on: true,),

              ),



              SizedBox(height: 30,),

              ButtonView(json: "assets/save.json", v: ()async{
                if(textViewModel.inputCheck() == true){
                  SetSubject set = SetSubject();

                  set.addUser(textViewModel.textController.text, int.parse(textViewModel.class_Controller.text), int.parse(textViewModel.report_Controller.text), int.parse(textViewModel.timeLimit_Controller.text));

                   textViewModel.dis();

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));

                }else{
                  ErrorShowDialog e = ErrorShowDialog(context: context, value: "文字列が入力されていないか、0が入力されました",ok:(){Navigator.pop(context);});

                  e.error().show();

                  print("入力足りへんわ！");
                }

              })

            ],
          ),
        )
      )
      )
    );
  }

}