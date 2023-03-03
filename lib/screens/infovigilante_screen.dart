import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seguricel_flutter/pages/login_page.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

typedef void ScreenCallback(int id);


class infoVigilanteScreen extends StatefulWidget {

  @override
  State<infoVigilanteScreen> createState() => _infoVigilanteScreenState();
}

class _infoVigilanteScreenState extends State<infoVigilanteScreen> {
  
  Map datosUsuario = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerDatos();
  }

  obtenerDatos()async{

    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    setState(() {
      datosUsuario = jsonDecode(encodeDatosUsuario);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      return false;
    },
    child: Scaffold(
            body: 
            (datosUsuario['nombre']!=null || datosUsuario['id_usuario']!=null || datosUsuario['contrato']!=null || datosUsuario['rol']!=null)
            ?Column(
              children: [
                SizedBox(
                  height:20
                ),
                Text("Informacion de vigilante", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                SizedBox(
                  height:10
                ),
                ListTile(
              leading: Icon(Icons.person, size: 60,),
              title: Text("Nombre", style: TextStyle(fontSize: 20),),
              subtitle: Text(datosUsuario['nombre'], style: TextStyle(fontSize: 20),),
              //trailing: Icon(Icons.edit),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_ind_rounded, size: 60,),
              title: Text("ID", style: TextStyle(fontSize: 20),),
              subtitle: Text(datosUsuario['id_usuario'], style: TextStyle(fontSize: 20)),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
              //trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.house_rounded, size: 60,),
              title: Text("Contrato", style: TextStyle(fontSize: 20),),
              subtitle: Text(datosUsuario['contrato'], style: TextStyle(fontSize: 20),),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
              //trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.accessibility_new_rounded, size: 60,),
              title: Text("Rol", style: TextStyle(fontSize: 20),),
              subtitle: Text(datosUsuario['rol'], style: TextStyle(fontSize: 20),),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
              //trailing: Icon(Icons.edit),
            ),
            // OutlinedButton(
            //   style: OutlinedButton.styleFrom(
            //     fixedSize: Size(200, 50),
            //     foregroundColor: Colors.red,
            //     //disabledForegroundColor: Colors.red,
            //     side: BorderSide(color: Colors.red, width: 3),
            //   ),
            //   onPressed:() {
            //   Constants.prefs.remove("datosUsuario");
            //   Constants.prefs.remove("accesos");
            //   Constants.prefs.remove("contratos");
            //   Constants.prefs.remove("isLoggedIn");
            //   Navigator.pushReplacementNamed(context, LoginPage.routeName);
            //   }, 
            //   child: Text("Cerrar sesion", style: TextStyle(fontSize: 20))
            // )
              ],
            ):LoadingWidget(),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(190, 50),
                    foregroundColor: Colors.red,
                    //disabledForegroundColor: Colors.red,
                    side: BorderSide(color: Colors.red, width: 3),
                  ),
                  onPressed:() {
                    AwesomeDialog(
                      btnCancelText: "NO",
                      btnOkText: "SI",
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black
                      ),
                      // descTextStyle: TextStyle(
                      //   fontWeight: FontWeight.bold,
                      //   fontSize: 20,
                      //   color: Colors.black
                      // ),
                      context: context,
                      animType: AnimType.bottomSlide,
                      headerAnimationLoop: false,
                      dialogType: DialogType.warning,
                      showCloseIcon: true,
                      title: "Seguro que desea cerrar su sesión?",
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                      Constants.prefs.remove("datosUsuario");
                      Constants.prefs.remove("accesos");
                      Constants.prefs.remove("contratos");
                      Constants.prefs.remove("isLoggedIn");
                      Constants.prefs.remove('entradas');
                      Constants.prefs.remove('salidas');
                      Constants.prefs.remove('servidor');
                      Constants.prefs.remove('id_usuario');
                      Constants.prefs.remove('contrato');
                      Constants.prefs.remove('beacon_uuid');
                      Constants.prefs.remove('modoInternet');
                      Constants.prefs.remove('modoWifi');
                      Constants.prefs.remove('modoBluetooth');
                      Constants.prefs.remove('imei');
                      Get.offNamed("/login");
                      // Navigator.pushReplacementNamed(context, LoginPage.routeName);
                      },
                    ).show();
                    }, 
                  child: Text("Cerrar sesión", style: TextStyle(fontSize: 18))
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
  );
}