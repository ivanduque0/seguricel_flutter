import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:http/http.dart' as http;

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerAccesos();

  }

  obtenerAccesos() async{
    String encodeSalidas = await Constants.prefs.getString('salidas').toString();
    servidor = await Constants.prefs.getString('servidor').toString();
    idUsuario = await Constants.prefs.getString('id_usuario').toString();
    contrato = await Constants.prefs.getString('contrato').toString();
    modoInternet = await Constants.prefs.getBool('modoInternet') ?? false;
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
                  Map jsonBody={"contrato":contrato, "acceso":acceso,"codigo_usuario":idUsuario, "razon":"salida"};
                  var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                  var res = await client.post(Uri.parse('https://webseguricel.up.railway.app/apertura/'), body: jsonBody).timeout(Duration(seconds: 5));
        
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
                            title: "Solicitud recibida, abriendo acceso",
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
      Map jsonBody={"contrato":contrato, "acceso":acceso,"codigo_usuario":idUsuario, "razon":"salida"};
      var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
      var res = await client.post(Uri.parse('https://webseguricel.up.railway.app/apertura/'), body: jsonBody).timeout(Duration(seconds: 5));
      //print(res.body);
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
          //print(timeoutInternet);
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
                title: "Solicitud recibida, abriendo acceso",
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
      //     title: "Solicitud recibida, abriendo acceso",
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