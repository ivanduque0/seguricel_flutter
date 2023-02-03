import 'dart:io';
import 'package:flutter/material.dart';
import 'package:seguricel_flutter/pages/main_page.dart';
import 'package:seguricel_flutter/pages/login_page.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Constants.prefs.getBool('isLoggedIn')==true?
      MainPage():
      LoginPage(),
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