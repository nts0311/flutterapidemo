import 'package:flutter/material.dart';
import 'package:flutterapidemo/screen/home.dart';
import 'package:flutterapidemo/service/bipower_service.dart';
import 'package:flutterapidemo/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {

          NetworkService.instance.buildContext = context;

          return ChangeNotifierProvider(
            create: (context) => HomeViewModel(),
            child: const HomeScreen(),
          );
        }
      )
    );

  }
}