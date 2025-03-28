
import 'package:aabbb/ViewModel/GetChartData.dart';
import 'package:firebase_core/firebase_core.dart';

import 'View/AppBarBase.dart';
import 'View/HomePageView.dart';
import 'ViewModel/GetClassAndReportData.dart';
import 'ViewModel/GetClassValue.dart';
import 'ViewModel/GetDate.dart';
import 'ViewModel/GetSubjectsData.dart';
import 'ViewModel/GetTimeLimit.dart';
import 'ViewModel/TextFieldViewModel.dart';
import 'RegistrationSubjects/addSubjectAndStudyTime.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TextFieldViewModel()),
          ChangeNotifierProvider(create: (_) => GetSubjectsData()),
          //ChangeNotifierProvider(create: (_) => GetClassAndReportData()),
          ChangeNotifierProvider(create: (_) => GetTimeLimit()),
          ChangeNotifierProvider(create: (_) => GetChartData()),
          ChangeNotifierProvider(create: (_) => GetDate()),
          ChangeNotifierProvider(create: (_) => GetClassValue()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomePageView homePageView = HomePageView(itemCount: 3);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(title: "自己管理アプリ"),

      body: homePageView,

      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddSubjectAndStudyTime()));
      },child: Lottie.asset("assets/add.json"),backgroundColor: Colors.lightBlueAccent,),
    );
  }
}
