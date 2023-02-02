import 'package:flutter/material.dart';
import 'package:seguricel_flutter/pages/main_page.dart';
import 'package:seguricel_flutter/pages/login_page.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: LoginPage(),
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    routes: {
      LoginPage.routeName : (context) => LoginPage(),
      MainPage.routeName : (context) => MainPage(),
    },
  );
  }
}