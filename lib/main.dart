import 'package:flutter/material.dart';
import 'package:seguricel_flutter/pages/home_page.dart';
import 'package:seguricel_flutter/pages/login_page.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
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
    home: LoginPage(),
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    routes: {
      LoginPage.routeName : (context) => LoginPage(),
      HomePage.routeName : (context) => HomePage(),
    },
  );
  }
}