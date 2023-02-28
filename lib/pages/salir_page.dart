import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:http/http.dart' as http;
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SalirPage extends StatefulWidget {
  const SalirPage({super.key});
  static const String routeName = "/salir";

  @override
  State<SalirPage> createState() => _SalirPageState();
}

class _SalirPageState extends State<SalirPage> {

  List salidas=[];
  String idUsuario="";
  String servidor="";
  String contrato="";
  bool modoInternet=false;
  String imei="";
  String uuid='';
  bool bluetooth=false;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    obtenerAccesos();
    obtenerUUID();

  }
  obtenerUUID( )async{
    bool bluetoothSP= await Constants.prefs.getBool('modoBluetooth') ?? false;
    String encodeUUID = await Constants.prefs.getString('salida_beacon_uuid').toString();
    setState(() {
      uuid = encodeUUID;
      bluetooth= bluetoothSP;
    });
  }

  obtenerAccesos() async{
    String encodeSalidas = await Constants.prefs.getString('salidas').toString();
    servidor = await Constants.prefs.getString('servidor').toString();
    idUsuario = await Constants.prefs.getString('id_usuario').toString();
    contrato = await Constants.prefs.getString('contrato').toString();
    modoInternet = await Constants.prefs.getBool('modoInternet') ?? false;
    imei = await Constants.prefs.getString('imei').toString();
    setState(() {
      salidas = jsonDecode(encodeSalidas);
      servidor;
      idUsuario;
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
        // Dialog(
        //   // The background color
        //   backgroundColor: Colors.white,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 20),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: const [
        //         // The loading indicator
        //         LoadingWidget(),
        //         SizedBox(
        //           height: 15,
        //         ),
        //         // Some text
        //         Text('Espere por favor...', style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.orange,
        //           fontSize: 30
        //         ),)
        //       ],
        //     ),
        //   ),
        // );
      }
    );
    if(!modoInternet){
      try {
        //print('${servidor}${idUsuario}/${acceso}/entrar/seguricel_wifi_activo/');
        var res = await http.post(Uri.parse('${servidor}${idUsuario}/${acceso}/salida/seguricel_wifi_activo')).timeout(Duration(seconds: 5));
        Navigator.of(context).pop();
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
          // onDismissCallback: (type) {
          //   debugPrint('Dialog Dissmiss from callback $type');
          // },
        ).show();
      } catch(e) {
        Navigator.of(context).pop();
        AwesomeDialog(
          btnCancelText: "NO",
          btnOkText: "SI",
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.red
          ),
          descTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black
          ),
          context: context,
          animType: AnimType.bottomSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          showCloseIcon: true,
          title: "Fallo abriendo por wifi",
          desc:"¿Desea intentar abrir por internet?",
          btnCancelOnPress: () {},
          btnOkOnPress: () {
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
              title: "Seguro que desea abrir por internet?",
              //desc:"¿Desea intentar abrir por internet?",
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: LoadingWidget());
                  }
                );
                try {

                  var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                  var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/sesionappapi/${idUsuario}/')).timeout(Duration(seconds: 5));
                  var sesiondata = await jsonDecode(res.body);
                  if (imei!=sesiondata['imei']){
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
                    Navigator.of(context).pop();
                    return Get.offNamed("/login");
                  }
                  Map jsonBody={"contrato":contrato, "acceso":acceso,"codigo_usuario":idUsuario, "razon":"salida"};
                  res = await client.post(Uri.parse('https://webseguricel.up.railway.app/apertura/'), body: jsonBody).timeout(Duration(seconds: 5));
        
                  if (res.statusCode==201){
                    int cantidadAperturas=0;
                    int feedbacksProcesados=0;
                    int timeoutInternet=0;
                    Timer.periodic(const Duration(seconds: 1), (timer) async {
                      timeoutInternet++;
                      try {
                        res = await client.get(Uri.parse('https://webseguricel.up.railway.app/aperturasusuarioapi/${idUsuario}/${contrato}/')).timeout(Duration(seconds: 5));
                        var aperturasjson = await jsonDecode(res.body);
                        //print(aperturasjson);
                        cantidadAperturas = aperturasjson.length;
                        feedbacksProcesados=0;
                        for (var apertura in aperturasjson) {
                          // print(apertura);
                          // print(apertura['abriendo']);
                          // print(apertura['feedback']);
                          if (apertura['abriendo'] && !apertura['feedback']){
                            //print(apertura);
                              res = await client.put(Uri.parse('https://webseguricel.up.railway.app/aperturasusuarioapi/${apertura['id']}/${contrato}/')).timeout(Duration(seconds: 5));
                              //print("FEEDBACK ENVIADO!");
                          }
                          if (apertura['abriendo'] && apertura['feedback']){
                            //print(apertura);
                            feedbacksProcesados+=1;
                          }
                        }
                      } catch (e) {
                      }
                        if (cantidadAperturas==feedbacksProcesados) {
                          timer.cancel();
                          Navigator.of(context).pop();
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
                            title: "¡Solicitud recibida!",
                            //desc:"Solicitud enviada",
                            btnOkOnPress: () {
                              //debugPrint('OnClcik');
                            },
                            btnOkIcon: Icons.check_circle,
                            // onDismissCallback: (type) {
                            //   debugPrint('Dialog Dissmiss from callback $type');
                            // },
                          ).show();
                          
                        } else if(timeoutInternet == 15 && cantidadAperturas!=feedbacksProcesados) {
                          timer.cancel();
                          Navigator.of(context).pop();
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
                            title: "No hubo respuesta del servidor",
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
                    });
                  } else {
                    Navigator.of(context).pop();
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
                      title: "No se pudo enviar la peticion",
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
                } catch(e) {
                  Navigator.of(context).pop();
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
                  // print("fallo internet");
                }
              },
              // onDismissCallback: (type) {
              //   debugPrint('Dialog Dissmiss from callback $type');
              // },
            ).show();
          },
          // onDismissCallback: (type) {
          //   debugPrint('Dialog Dissmiss from callback $type');
          // },
        ).show();
      }
    } else {
      try {
      var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
      var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/sesionappapi/${idUsuario}/')).timeout(Duration(seconds: 5));
      var sesiondata = await jsonDecode(res.body);
      if (imei!=sesiondata['imei']){
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
        Navigator.of(context).pop();
        return Get.offNamed("/login");
      }
      Map jsonBody={"contrato":contrato, "acceso":acceso,"codigo_usuario":idUsuario, "razon":"salida"};
      res = await client.post(Uri.parse('https://webseguricel.up.railway.app/apertura/'), body: jsonBody).timeout(Duration(seconds: 5));
      //await Future.delayed(const Duration(seconds: 1));
      // Navigator.of(context).pop();
      // AwesomeDialog(
      //   titleTextStyle: TextStyle(
      //     fontWeight: FontWeight.bold,
      //     fontSize: 30,
      //     color: Colors.green
      //   ),
      //   // descTextStyle: TextStyle(
      //   //   fontWeight: FontWeight.bold,
      //   //   fontSize: 20,
      //   // ),
      //   context: context,
      //   animType: AnimType.bottomSlide,
      //   headerAnimationLoop: false,
      //   dialogType: DialogType.success,
      //   showCloseIcon: true,
      //   title: "Solicitud enviada",
      //   //desc:"Solicitud enviada",
      //   btnOkOnPress: () {
      //     //debugPrint('OnClcik');
      //   },
      //   btnOkIcon: Icons.check_circle,
      //   // onDismissCallback: (type) {
      //   //   debugPrint('Dialog Dissmiss from callback $type');
      //   // },
      // ).show();
      if (res.statusCode==201){
        int cantidadAperturas=0;
        int feedbacksProcesados=0;
        int timeoutInternet=0;
        Timer.periodic(const Duration(seconds: 1), (timer) async {
          timeoutInternet++;
          try {
            res = await client.get(Uri.parse('https://webseguricel.up.railway.app/aperturasusuarioapi/${idUsuario}/${contrato}/')).timeout(Duration(seconds: 5));
            var aperturasjson = await jsonDecode(res.body);
            // print(aperturasjson);
            cantidadAperturas = aperturasjson.length;
            feedbacksProcesados=0;
            for (var apertura in aperturasjson) {
              // print(apertura);
              // print(apertura['abriendo']);
              // print(apertura['feedback']);
              if (apertura['abriendo'] && !apertura['feedback']){
                //print(apertura);
                  res = await client.put(Uri.parse('https://webseguricel.up.railway.app/aperturasusuarioapi/${apertura['id']}/${contrato}/')).timeout(Duration(seconds: 5));
                  //print("FEEDBACK ENVIADO!");
              }
              if (apertura['abriendo'] && apertura['feedback']){
                //print(apertura);
                feedbacksProcesados+=1;
              }
            }
          } catch (e) {
          }
            if (cantidadAperturas==feedbacksProcesados) {
              timer.cancel();
              Navigator.of(context).pop();
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
                title: "¡Solicitud recibida!",
                //desc:"Solicitud enviada",
                btnOkOnPress: () {
                  //debugPrint('OnClcik');
                },
                btnOkIcon: Icons.check_circle,
                // onDismissCallback: (type) {
                //   debugPrint('Dialog Dissmiss from callback $type');
                // },
              ).show();
              
            } else if(timeoutInternet == 15 && cantidadAperturas!=feedbacksProcesados) {
              timer.cancel();
              Navigator.of(context).pop();
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
                title: "No hubo respuesta del servidor",
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
          });
      } else {
        Navigator.of(context).pop();
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
          title: "No se pudo enviar la peticion",
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



      // do {
        
      //   res = await client.get(Uri.parse('https://webseguricel.up.railway.app/aperturasusuarioapi/${idUsuario}/${contrato}/')).timeout(Duration(seconds: 5));
      //   var aperturasjson = await jsonDecode(res.body);
      //   // print(aperturasjson);
      //   cantidadAperturas = aperturasjson.length;
      //   feedbacksProcesados=0;
      //   try {
      //     for (var apertura in aperturasjson) {
      //       // print(apertura);
      //       // print(apertura['abriendo']);
      //       // print(apertura['feedback']);
      //       if (apertura['abriendo'] && !apertura['feedback']){
      //         //print(apertura);
      //           res = await client.put(Uri.parse('https://webseguricel.up.railway.app/aperturasusuarioapi/${apertura['id']}/${contrato}/')).timeout(Duration(seconds: 5));
      //           //print("FEEDBACK ENVIADO!");
      //       }
      //       if (apertura['abriendo'] && apertura['feedback']){
      //         //print(apertura);
      //         feedbacksProcesados+=1;
      //       }
      //     }
      //   } catch (e) {
      //   }

      // } while (cantidadAperturas>feedbacksProcesados);
      // Navigator.of(context).pop();
      // if(cantidadAperturas==feedbacksProcesados){
      //   AwesomeDialog(
      //     titleTextStyle: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 30,
      //       color: Colors.green
      //     ),
      //     // descTextStyle: TextStyle(
      //     //   fontWeight: FontWeight.bold,
      //     //   fontSize: 20,
      //     // ),
      //     context: context,
      //     animType: AnimType.bottomSlide,
      //     headerAnimationLoop: false,
      //     dialogType: DialogType.success,
      //     showCloseIcon: true,
      //     title: "¡Solicitud recibida!",
      //     //desc:"Solicitud enviada",
      //     btnOkOnPress: () {
      //       //debugPrint('OnClcik');
      //     },
      //     btnOkIcon: Icons.check_circle,
      //     // onDismissCallback: (type) {
      //     //   debugPrint('Dialog Dissmiss from callback $type');
      //     // },
      //   ).show();
      // }
      // } else {
      //   AwesomeDialog(
      //     titleTextStyle: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 30,
      //       color: Colors.red
      //     ),
      //     // descTextStyle: TextStyle(
      //     //   fontWeight: FontWeight.bold,
      //     //   fontSize: 20,
      //     // ),
      //     context: context,
      //     animType: AnimType.bottomSlide,
      //     headerAnimationLoop: false,
      //     dialogType: DialogType.error,
      //     showCloseIcon: true,
      //     title: "No hubo respuesta del servidor",
      //     //desc:"Solicitud enviada",
      //     btnOkOnPress: () {
      //       //debugPrint('OnClcik');
      //     },
      //     btnOkColor: Colors.red,
      //     btnOkIcon: Icons.check_circle,
      //     // onDismissCallback: (type) {
      //     //   debugPrint('Dialog Dissmiss from callback $type');
      //     // },
      //   ).show();
      // }
      } catch(e) {
        Navigator.of(context).pop();
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
          title: "Fallo al enviar o procesar la peticion",
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
        // print("fallo internet");
      }
    }

    if (!mounted) return;


  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        floatingActionButton: _hideShowBluetooth(),
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

  Widget _hideShowBluetooth() {
    if (!bluetooth) {
      return Container();
    } else {
      return FloatingActionButton.large(
        backgroundColor: Color.fromARGB(255, 2, 49, 255),
        onPressed: () async {
          bool bluetoothEnable = _bluetoothState.isEnabled;
          // bool isAdvertising = await Constants.beaconBroadcast.isAdvertising() ?? false;
          // if (!bluetoothEnable){
          //   await FlutterBluetoothSerial.instance.requestEnable();
          // }
          // else{
          //   await FlutterBluetoothSerial.instance.requestDisable();
          // }
          Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothAdvertise,
          // Permission.locationWhenInUse,
          // Permission.locationAlways
          ].request();
          //print(statuses);
          //print(bluetoothEnable);
          if (!bluetoothEnable){
            await FlutterBluetoothSerial.instance.requestEnable();
            // setState(() {
            //   isAdvertising;
            // });
            
            // print(isAdvertising);
            // print("activar bluetooth");
            Constants.beaconBroadcast
              .setUUID(uuid)
              .setMajorId(8462)
              .setMinorId(37542)
              .setTransmissionPower(10)
              .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
              .setManufacturerId(0x004c)
              .setAdvertiseMode(AdvertiseMode.lowLatency)
              .start();

            // print(isAdvertising);
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
              animType: AnimType.topSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.info,
              showCloseIcon: true,
              title: "¡Transmitiendo por bluetooth!",
              //desc:"Solicitud enviada",
              btnOkColor: Colors.blue,
              btnOkOnPress: () {
                //debugPrint('OnClcik');
              },
              btnOkIcon: Icons.check_circle,
              // onDismissCallback: (type) {
              //   debugPrint('Dialog Dissmiss from callback $type');
              // },
            ).show();
          await Future.delayed(const Duration(seconds: 30), () async {
            bool isAdvertising = await Constants.beaconBroadcast.isAdvertising() ?? false;
            if (_bluetoothState.isEnabled || isAdvertising){
              await Constants.beaconBroadcast.stop();
              // await FlutterBluetoothSerial.instance.requestDisable();
            }
            
          });

          

        } else {
          Constants.beaconBroadcast
            .setUUID(uuid)
            .setMajorId(8462)
            .setMinorId(37542)
            .setTransmissionPower(10)
            .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
            .setManufacturerId(0x004c)
            .setAdvertiseMode(AdvertiseMode.lowLatency)
            .start();

          // print(isAdvertising);
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
            animType: AnimType.topSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.info,
            showCloseIcon: true,
            title: "¡Transmitiendo por bluetooth!",
            //desc:"Solicitud enviada",
            btnOkColor: Colors.blue,
            btnOkOnPress: () {
              //debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            // onDismissCallback: (type) {
            //   debugPrint('Dialog Dissmiss from callback $type');
            // },
          ).show();
        await Future.delayed(const Duration(seconds: 30), () async {
          bool isAdvertising = await Constants.beaconBroadcast.isAdvertising() ?? false;
          if (_bluetoothState.isEnabled || isAdvertising){
            await Constants.beaconBroadcast.stop();
            // await FlutterBluetoothSerial.instance.requestDisable();
          }
          
        });
        }
        // } else {
        //   await Constants.beaconBroadcast.stop();

        //   FlutterBluetoothSerial.instance.requestDisable();

        //   AwesomeDialog(
        //       titleTextStyle: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 30,
        //         color: Colors.red
        //       ),
        //       // descTextStyle: TextStyle(
        //       //   fontWeight: FontWeight.bold,
        //       //   fontSize: 20,
        //       // ),
        //       context: context,
        //       animType: AnimType.topSlide,
        //       headerAnimationLoop: false,
        //       dialogType: DialogType.info,
        //       showCloseIcon: true,
        //       title: "¡Apagando transmision por bluetooth!",
        //       //desc:"Solicitud enviada",
        //       btnOkColor: Colors.blue,
        //       btnOkOnPress: () {
        //         //debugPrint('OnClcik');
        //       },
        //       btnOkIcon: Icons.check_circle,
        //       // onDismissCallback: (type) {
        //       //   debugPrint('Dialog Dissmiss from callback $type');
        //       // },
        //     ).show();
        // }
        },
        child: new IconTheme(
            data: new IconThemeData(color: Colors.white), 
            child: new Icon(Icons.bluetooth_rounded, size: 80),
        )
      );
    }
  }

}