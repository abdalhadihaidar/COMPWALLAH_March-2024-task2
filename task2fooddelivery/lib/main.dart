import 'package:flutter/material.dart';
import 'package:task2fooddelivery/firstscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'food delivery pred',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstScreen(), // Set FirstScreen as the initial screen of your app
    );
  }
}