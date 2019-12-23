import 'package:flutter/material.dart';
import './views/home.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFFF9F9FA),
      ),
      home: new Home(),
    );
  }
}
