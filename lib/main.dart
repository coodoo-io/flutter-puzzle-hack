import 'dart:async';

import 'package:flutter/material.dart';
import 'package:puzzle/screens/start_screen.dart';

void main() {
  runApp(MyApp());
}

final streamController = StreamController();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartScreenWidget(),
    );
  }
}
