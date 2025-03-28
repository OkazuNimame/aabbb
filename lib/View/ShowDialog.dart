import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/widgets.dart';

class ErrorShowDialog {

  BuildContext context;
  String value;
  VoidCallback? ok,cancel;

  ErrorShowDialog({required this.context,required this.value,this.ok,this.cancel});

  AwesomeDialog error(){
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'エラーが起きました',
        desc: '$value',
    btnOkOnPress:  ok,
    )..show();
  }
}

class DeleteCheckDialog{
  BuildContext context;
  String value;
  VoidCallback? ok;
  VoidCallback? cancel;

  DeleteCheckDialog({required this.context,required this.value,this.ok,this.cancel});

  AwesomeDialog deleteLog(){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: "削除ダイアログ",
      desc: '$value',
      btnCancelOnPress: cancel,
      btnOkOnPress: ok

    )..show();
  }
}