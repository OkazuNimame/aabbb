import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../ViewModel/TextFieldViewModel.dart';

class TextFieldView extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType textInputType;
  final TextInputFormatter? v;
  final int? maxLines;
   bool? on = true;

  TextFieldView({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.textInputType,
    this.v,
    this.maxLines,
    this.on
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TextFieldViewModel(), // 各 TextFieldView に独立した ViewModel を作成
      child: Consumer<TextFieldViewModel>(
        builder: (context, textViewModel, child) {
          return TextField(
            controller: controller,
            keyboardType: textInputType,
            inputFormatters: v == null? []:[v!],
            onChanged: (value) {
              if (textInputType == TextInputType.number) {
                textViewModel.checkNumberText(controller);
              } else {
                textViewModel.checkStringText(controller);
              }
            },
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              suffixIcon:on == true? textViewModel.check
                  ? Icon(Icons.check, color: Colors.green)
                  : Icon(Icons.close, color: Colors.red):null,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black,width: 3),
              ),
            ),
          );
        },
      ),
    );
  }
}
