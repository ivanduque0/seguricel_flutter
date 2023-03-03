import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seguricel_flutter/controllers/rol_controller.dart';
import 'package:seguricel_flutter/controllers/screens_unidad_controller.dart';
import 'package:seguricel_flutter/pages/entrar_page.dart';
import 'package:seguricel_flutter/pages/salir_page.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class AperturasScreen extends StatefulWidget {
  const AperturasScreen({super.key});
  static const String routeName = "/main";

  @override
  State<AperturasScreen> createState() => _AperturasScreenState();
}

class _AperturasScreenState extends State<AperturasScreen> {

  ScreensUnidadController screensUnidadController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      screensUnidadController.cambiarScreen(1);
      // widget.volver(1);
      return false;
    },
    child: Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.pushNamed(context, EntrarPage.routeName);
              }, // Handle your callback.
              splashColor: Colors.brown.withOpacity(0.5),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 30, 255, 41),
                  primary: Colors.black,
                ),
                onPressed: (() async {
                  Get.toNamed("/entrar");
                }), 
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3,
                  child: Center(
                    child: Text("ENTRAR",
                            style: TextStyle(fontSize: 60),),
                  ),
                  // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20)
                    
                  // ),
                ),
              ),
              // Ink(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height/3,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     image: DecorationImage(
              //       image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.pushNamed(context, SalirPage.routeName);
              }, // Handle your callback.
              splashColor: Colors.brown.withOpacity(0.5),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  primary: Colors.black,
                ),
                onPressed: (() async {
                  Get.toNamed("/salir");
                }), 
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3,
                  child: Center(
                    child: Text("SALIR",
                            style: TextStyle(fontSize: 60),),
                  ),
                  // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20)
                    
                  // ),
                ),
              )
            ),
          ],
        ),
      ),
    )
  );
}