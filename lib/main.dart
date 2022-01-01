import 'package:flutter/material.dart';

import 'accelerator_design.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home:  MyApp()
  )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DialGauge(),


    );
  }
}
