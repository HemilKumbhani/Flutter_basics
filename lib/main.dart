import 'package:Talkies/utils/Strings.dart';
import 'package:flutter/material.dart';

import 'homeScreen/HomePage.dart';
import 'imports.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomePage()
      },
    );
  }
}
