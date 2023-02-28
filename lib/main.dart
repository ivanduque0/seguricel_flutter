import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seguricel_flutter/pages/agregar_invitados_page.dart';
import 'package:seguricel_flutter/pages/eliminar_invitados_page.dart';
import 'package:seguricel_flutter/pages/entrar_page.dart';
import 'package:seguricel_flutter/pages/main_page.dart';
import 'package:seguricel_flutter/pages/login_page.dart';
import 'package:seguricel_flutter/pages/salir_page.dart';
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
    return GetMaterialApp (
      debugShowCheckedModeBanner: false,
      // home: Constants.prefs.getBool('isLoggedIn')==true?
      // MainPage():
      // LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: Constants.prefs.getBool('isLoggedIn')==true?"/main":"/login",
      getPages: [
        GetPage(name: "/main", page: ()=>MainPage()),
        GetPage(name: "/login", page: ()=>LoginPage()),
        GetPage(name: "/entrar", page: ()=>EntrarPage()),
        GetPage(name: "/salir", page: ()=>SalirPage()),
        GetPage(name: "/eliminarinvitados", page: ()=>EliminarInvitadosPage()),
        GetPage(name: "/agregarinvitados", page: ()=>AgregarInvitadosPage()),
      ],
    //   routes: {
    //     LoginPage.routeName : (context) => LoginPage(),
    //     MainPage.routeName : (context) => MainPage(),
    //     EntrarPage.routeName : (context) => EntrarPage(),
    //     SalirPage.routeName : (context) => SalirPage(),
    // },
  );
  }
}