import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:http/http.dart' as http;
import 'package:seguricel_flutter/controllers/codigo_unidad_controller.dart';
import 'package:seguricel_flutter/controllers/personas_unidad_controller.dart';
import 'package:seguricel_flutter/controllers/personas_visitante_controller.dart';
import 'package:seguricel_flutter/controllers/screens_unidad_controller.dart';
import 'package:seguricel_flutter/controllers/codigo_visitante_controller.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import '../controllers/apertura_visitante_controller.dart';
class SalirPage extends StatefulWidget {
  const SalirPage({super.key});
  static const String routeName = "/salir";

  @override
  State<SalirPage> createState() => _SalirPageState();
}

class _SalirPageState extends State<SalirPage> {

  CodigoUnidadController codigoUnidadController = Get.find();
  CodigoVisitanteController codigoVisitanteController = Get.find();
  PersonasUnidadController personasUnidadController = Get.find();
  PersonasVisitanteController personasVisitanteController = Get.find();
  ScreensUnidadController screensUnidadController = Get.find();
  ScreensVisitantesController screensVisitantesController = Get.find();
  AperturaVisitanteController aperturaVisitanteController = Get.find();


  List salidas=[];
  String idVigilante="";
  String servidor="";
  String contrato="";
  bool modoInternet=false;
  String imei="";
  String uuid='';
  @override
  void initState() {
    // TODO: implement initState
    obtenerAccesos();
    super.initState();

  }

  obtenerAccesos() async{
    String encodeSalidas = await Constants.prefs.getString('salidas').toString();
    idVigilante = await Constants.prefs.getString('id_usuario').toString();
    servidor = await Constants.prefs.getString('servidor').toString();
    contrato = await Constants.prefs.getString('contrato').toString();
    imei = await Constants.prefs.getString('imei').toString();
    setState(() {
      salidas = jsonDecode(encodeSalidas);
      servidor;
      idVigilante;
      // print(servidor);
      // print(entradas);
    });
  }

  enviarPeticion(String acceso, [bool mounted = true]) async {
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: LoadingWidget());
      }
    );
    try {
      if (aperturaVisitanteController.visitante==true){
        //print('${servidor}${idVigilante}/${codigoVisitanteController.codigo}/${personasVisitanteController.personas}/${acceso}/salida/seguricel_wifi_vigilante_invitado');
        var res = await http.post(Uri.parse('${servidor}${idVigilante}/${codigoVisitanteController.codigo}/${personasVisitanteController.personas}/${acceso}/salida/seguricel_wifi_vigilante_invitado')).timeout(Duration(seconds: 5));
        //print(res.statusCode);
        Navigator.of(context).pop();

        if (res.statusCode==200){
          AwesomeDialog(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.green
            ),
            // descTextStyle: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   fontSize: 20,
            // ),
            context: context,
            animType: AnimType.bottomSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: true,
            title: "Solicitud enviada",
            //desc:"Solicitud enviada",
            btnOkOnPress: () {
              //debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              codigoVisitanteController.cambiarCodigo("");
              screensVisitantesController.cambiarScreen(0);
              aperturaVisitanteController.cambiarVisitante(false);

              Get.back();
              // debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();
        } else {
          AwesomeDialog(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.red
            ),
            // descTextStyle: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   fontSize: 20,
            // ),
            context: context,
            animType: AnimType.bottomSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.error,
            showCloseIcon: true,
            title: "La invitacion aun no se ha procesado por completo",
            //desc:"Solicitud enviada",
            btnOkOnPress: () {
              //debugPrint('OnClcik');
            },
            btnOkColor: Colors.red,
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              codigoVisitanteController.cambiarCodigo("");
              screensVisitantesController.cambiarScreen(0);
              aperturaVisitanteController.cambiarVisitante(false);
              Get.back();
              // debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show();
        }
      
      } else {
      
        //print('${servidor}${idVigilante}/${codigoUnidadController.codigo}/${personasUnidadController.personas}/${acceso}/salida/seguricel_wifi_vigilante');
        var res = await http.post(Uri.parse('${servidor}${idVigilante}/${codigoUnidadController.codigo}/${personasUnidadController.personas}/${acceso}/salida/seguricel_wifi_vigilante')).timeout(Duration(seconds: 5));
        //print(res.statusCode);
        Navigator.of(context).pop();
        if (res.statusCode==200){
          AwesomeDialog(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.green
            ),
            // descTextStyle: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   fontSize: 20,
            // ),
            context: context,
            animType: AnimType.bottomSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: true,
            title: "Solicitud enviada",
            //desc:"Solicitud enviada",
            btnOkOnPress: () {
              //debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              codigoUnidadController.cambiarCodigo("");
              personasUnidadController.cambiarpersonas("");
              screensUnidadController.cambiarScreen(0);
              Get.back();
              // debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();
        } else {
          AwesomeDialog(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.red
            ),
            // descTextStyle: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   fontSize: 20,
            // ),
            context: context,
            animType: AnimType.bottomSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.error,
            showCloseIcon: true,
            title: "No existe una unidad con el codigo introducido",
            //desc:"Solicitud enviada",
            btnOkOnPress: () {
              //debugPrint('OnClcik');
            },
            btnOkColor: Colors.red,
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              codigoUnidadController.cambiarCodigo("");
              personasUnidadController.cambiarpersonas("");
              screensUnidadController.cambiarScreen(0);
              Get.back();
              // debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show();
        }
      }
    } catch(e) {
      Navigator.of(context).pop();
      if (e is TimeoutException){
        AwesomeDialog(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
          // descTextStyle: TextStyle(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 20,
          // ),
          context: context,
          animType: AnimType.bottomSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.warning,
          showCloseIcon: true,
          title: "Tiempo de espera agotado",
          //desc:"Solicitud enviada",
          btnOkOnPress: () {
            //debugPrint('OnClcik');
          },
          btnOkColor: Color.fromARGB(255, 245, 177, 61),
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            codigoUnidadController.cambiarCodigo("");
            codigoVisitanteController.cambiarCodigo("");
            personasUnidadController.cambiarpersonas("");
            screensUnidadController.cambiarScreen(0);
            screensVisitantesController.cambiarScreen(0);
            aperturaVisitanteController.cambiarVisitante(false);
            Get.back();
          },
        ).show();
      } else {
        AwesomeDialog(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.red
          ),
          // descTextStyle: TextStyle(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 20,
          // ),
          context: context,
          animType: AnimType.bottomSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          showCloseIcon: true,
          title: "Fallo al enviar la peticion",
          //desc:"Solicitud enviada",
          btnOkOnPress: () {
            //debugPrint('OnClcik');
          },
          btnOkColor: Colors.red,
          btnOkIcon: Icons.check_circle,
          // onDismissCallback: (type) {
          //   debugPrint('Dialog Dissmiss from callback $type');
          // },
        ).show();
      }
    }

    if (!mounted) return;


  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          child: salidas!=[] || salidas!=null?ListView.builder(
        itemBuilder: (context, index){
          return ListTile(
            title: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 250, 202, 163),
                  primary: Colors.black,
                ),
                onPressed: (() {
                //print(salidas[index]['descripcion']);
                enviarPeticion(salidas[index]['acceso']);
                // AwesomeDialog(
                //   context: context,
                //   animType: AnimType.leftSlide,
                //   headerAnimationLoop: true,
                //   dialogType: DialogType.success,
                //   showCloseIcon: true,
                //   title: 'Succes',
                //   desc:
                //       'Dialog description here..................................................',
                //   btnOkOnPress: () {
                //     debugPrint('OnClcik');
                //   },
                //   btnOkIcon: Icons.check_circle,
                //   onDismissCallback: (type) {
                //     debugPrint('Dialog Dissmiss from callback $type');
                //   },
                // ).show();

                }),
                child: Container(
                  child: Text(salidas[index]['descripcion'],
                          style: TextStyle(fontSize: 60),textAlign: TextAlign.center,),
                  // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20)

                  // ),
                ),
              ),
            ),
            // subtitle: Text("Descripcion: ${accesos[index]["descripcion"]}"),
            // leading: Icon(Icons.device_hub),
          );
        },
        itemCount: salidas.length,
        ):LoadingWidget()
        ),
          )
    );
  }
}