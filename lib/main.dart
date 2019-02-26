import 'package:flutter/material.dart';
import 'imports.dart';
import 'webDetail/webDetails.dart';
import 'auth/auth_page.dart';
import 'auth/login_page.dart';
import 'auth/login_form.dart';
import 'package:web_view_app/bottomNavigation/bottom_navigation.dart';
import 'auth/sign_up_page.dart';
import 'homeScreen/home_page.dart';

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
