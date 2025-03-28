import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NoDataPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset("assets/not.json"),
          SizedBox(height: 10,),
          Text("No Data Found!",style: GoogleFonts.shipporiMincho(fontSize: 40),)
        ],
      ),
    );
  }
  
}