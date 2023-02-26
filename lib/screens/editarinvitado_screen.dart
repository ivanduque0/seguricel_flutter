import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:intl/intl.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/controllers/horarios_controller.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:seguricel_flutter/utils/invitacion.dart';
import 'package:get/get.dart';

typedef void ScreenCallback(int id);

class EditarInvitadosScreen extends StatefulWidget {
  // final ScreenCallback volver;
  // EditarInvitadosScreen({required this.volver});

  @override
  State<EditarInvitadosScreen> createState() => _EditarInvitadosScreenState();
}

class _EditarInvitadosScreenState extends State<EditarInvitadosScreen> {
  Map datosPropietario={};
  Map datosInvitado={};
  ScreensVisitantesController controller = Get.find();
  HorariosController horariosController = Get.put(HorariosController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerInvitado();
  }

  obtenerInvitado() async {
    horariosController.cambiarhorarios([]);
    String encodeDatosInvitado = await Constants.prefs.getString('datosInvitadoEditar').toString();
    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    //print(idUsuario);
    datosInvitado=  jsonDecode(encodeDatosInvitado);
    // print(encodeDatosUsuario);
    // print(encodeContratos);
    // print(encodeAccesos);
    //print(datosInvitado);
    setState (() {
      datosInvitado= jsonDecode(encodeDatosInvitado);
      datosPropietario = jsonDecode(encodeDatosUsuario);
      //print(datosInvitado);
      //horariosInvitado= (jsonDecode(encodeDatosInvitados) as List<dynamic>).cast<Map>();
    });
    // print(datosInvitado);
    try {
      List horariosInvitado=[];
      var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
      var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${datosInvitado['id']}/')).timeout(Duration(seconds: 5));
      //print(res.body);
      //horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
      setState(() {
        horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
      });
      horariosController.cambiarhorarios(horariosInvitado);
      //print(horariosInvitado);
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      controller.cambiarScreen(1);
      // widget.volver(1);
      return false;
    },
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                (datosInvitado['nombre']!=null || datosInvitado['codigo']!=null)
                ?Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('Informacion del invitado', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text("Nombre", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              subtitle: Text(datosInvitado['nombre'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              //trailing: Icon(Icons.edit),
                              onTap: () {
                                // print(datosUsuario);
                                // print("a");
                              },
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text("Codigo", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              subtitle: Text(datosInvitado['codigo'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              //trailing: Icon(Icons.edit),
                              onTap: () {
                                // print(datosUsuario);
                                // print("a");
                              },
                            ),
                          ),
                        ],
                      ),
                      // (datosUsuario=={})
                      // ?LoadingWidget()
                      // :(datosUsuario!={} && invitados==[])
                      // ?Text('Actualmente no tiene invitados', 
                      //   textAlign: TextAlign.center, 
                      //   style: TextStyle(
                      //     fontSize: 30,
                      //     fontWeight: FontWeight.bold
                      //   ),
                      // )
                      SizedBox(
                        height: 30,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Text("Entrada", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width/5,
                      //     ),
                      //     Text("Salida", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),)
                      //   ],
                      // ),
                      horariosController.horarios.length!=0?Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/3.5,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(
                      //       color: Color.fromARGB(255, 240, 162, 73),
                      //       width: 3,
                      //     )
                      //   ),
                      child: GetBuilder<HorariosController>(builder: (horariosController){ 
                        return CustomScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              return GestureDetector(
                                onTap: () async {

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
                                    title: "¿Desea reenviar la informacion de la invitacion por whatsapp?",
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
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
                                        String mensaje='INVITACION RES. ${datosPropietario['contrato']}\n\nNombre: ${datosInvitado['nombre']}\nCodigo: ${datosInvitado['codigo']}\nFecha: ${horariosController.horarios[index]['fecha_entrada']}\nAcompañantes: ${horariosController.horarios[index]['acompanantes']}\n\nSi desea abrir con su telefono por proximidad via Bluetooth, descargue la aplicacion.\n\nAndroid: ${Constants.linkAndroid}\n\niOs: ${Constants.linkIOS}';
                                        // print(mensaje);
                                        var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                                        var res = await client.get(Uri.parse('https://api.callmebot.com/whatsapp.php?phone=${Constants.numeroBot}&text=!sendto+${datosPropietario['numero_telefonico']}+${mensaje}&apikey=${Constants.apiKeyBot}')).timeout(Duration(seconds: 5));
                                        // var dataMensajes = res.body;
                                        Navigator.of(context).pop();
                                        AwesomeDialog(
                                          //autoHide: Duration(seconds: 3),
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
                                          dialogType: DialogType.success,
                                          showCloseIcon: true,
                                          title: "Informacion enviada, por favor revise su whatsapp",
                                          //desc:"Solicitud enviada",
                                          btnOkColor: Colors.green,
                                          btnOkOnPress: () {
                                            
                                            //debugPrint('OnClcik');
                                          },
                                          btnOkIcon: Icons.check_circle,
                                          // onDismissCallback: (type) {
                                          //   //debugPrint('Dialog Dissmiss from callback $type');
                                          // },
                                        ).show();
                                      } catch (e) {
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
                                          title: "No hubo respuesta del servidor, vuelva a intentarlo",
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
                                    },
                                  ).show();


                                 
                                },
                                child: Invitacion(
                                  fecha_entrada:horariosController.horarios[index]['fecha_entrada'], 
                                  fecha_salida:horariosController.horarios[index]['fecha_salida'],
                                  hora_entrada:DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosController.horarios[index]['entrada'])), 
                                  hora_salida:DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosController.horarios[index]['salida'])),
                                  horario_id: horariosController.horarios[index]['id'],
                                  usuario_id: horariosController.horarios[index]['usuario'],
                                  acompanantes: horariosController.horarios[index]['acompanantes'],
                                  ),
                              );
                              // return Container(
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Expanded(
                              //         child: ListTile(
                              //           // leading: Icon(Icons.person),
                              //           title:Text(horariosInvitado[index]['fecha_entrada'], textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                              //           subtitle: Text(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosInvitado[index]['entrada'])), textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              //           // trailing: Row(
                              //           //   mainAxisSize: MainAxisSize.min,
                              //           //   children: [
                              //           //     IconButton(
                              //           //     icon: Icon(Icons.edit), 
                              //           //     color: Colors.blue,
                              //           //     onPressed: () {
                              //           //       TimeOfDay prueba = stringToTimeOfDay(horariosInvitado[index]['entrada']);
                              //           //       // var prueba= DateTime.parse(horariosInvitado[index]['fecha_entrada']+" "+horariosInvitado[index]['entrada']);
                              //           //       print(prueba);
                              //           //       print(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosInvitado[index]['entrada'])));
                              //           //     },
                              //           //     ),
                              //           //     SizedBox(width: 10,),
                              //           //     IconButton(
                              //           //       icon: Icon(Icons.delete), color: Colors.red,
                              //           //       onPressed: () async {
                              //           //       }, 
                              //           //     ),
                              //           //   ],
                              //           // ),
                              //           // onTap: () async {
                                    
                              //           // },
                              //         ),
                              //       ),
                              //       IconButton(
                              //         iconSize: 40,
                              //         icon: Icon(Icons.delete), color: Colors.red,
                              //         onPressed: () async {
                              //           AwesomeDialog(
                              //             btnCancelText: "NO",
                              //             btnOkText: "SI",
                              //             titleTextStyle: TextStyle(
                              //               fontWeight: FontWeight.bold,
                              //               fontSize: 20,
                              //               color: Colors.black
                              //             ),
                              //             // descTextStyle: TextStyle(
                              //             //   fontWeight: FontWeight.bold,
                              //             //   fontSize: 20,
                              //             //   color: Colors.black
                              //             // ),
                              //             context: context,
                              //             animType: AnimType.bottomSlide,
                              //             headerAnimationLoop: false,
                              //             dialogType: DialogType.warning,
                              //             showCloseIcon: true,
                              //             title: "¿Seguro que desea eliminar el horario?",
                              //             btnCancelOnPress: () {},
                              //             btnOkOnPress: () async {
                              //               showDialog(
                              //                 // The user CANNOT close this dialog  by pressing outsite it
                              //                 barrierDismissible: false,
                              //                 context: context,
                              //                 builder: (_) {
                              //                   return WillPopScope(
                              //                     onWillPop: () async => false,
                              //                     child: LoadingWidget());
                              //                 }
                              //               );
                              //               try {
                              //                 var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                              //                 var res = await client.delete(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${horariosInvitado[index]['id']}/')).timeout(Duration(seconds: 5));
                              //                 //horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                              //                 res = await client.get(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${horariosInvitado[index]['usuario']}/')).timeout(Duration(seconds: 5));
                              //                 //horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                              //                 setState(() {
                              //                   horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                              //                 });
                              //                 Navigator.of(context).pop();
                              //                 AwesomeDialog(
                              //                   titleTextStyle: TextStyle(
                              //                     fontWeight: FontWeight.bold,
                              //                     fontSize: 30,
                              //                     color: Colors.green
                              //                   ),
                              //                   // descTextStyle: TextStyle(
                              //                   //   fontWeight: FontWeight.bold,
                              //                   //   fontSize: 20,
                              //                   // ),
                              //                   context: context,
                              //                   animType: AnimType.topSlide,
                              //                   headerAnimationLoop: false,
                              //                   dialogType: DialogType.success,
                              //                   showCloseIcon: true,
                              //                   title: "¡Horario eliminado con exito!",
                              //                   //desc:"Solicitud enviada",
                              //                   btnOkColor: Colors.green,
                              //                   btnOkOnPress: () {
                              //                     //debugPrint('OnClcik');
                              //                   },
                              //                   btnOkIcon: Icons.check_circle,
                              //                   // onDismissCallback: (type) {
                              //                   //   debugPrint('Dialog Dissmiss from callback $type');
                              //                   // },
                              //                 ).show();
                              //               } catch (e) {
                              //                 Navigator.of(context).pop();
                              //                 AwesomeDialog(
                              //                   titleTextStyle: TextStyle(
                              //                     fontWeight: FontWeight.bold,
                              //                     fontSize: 30,
                              //                     color: Colors.red
                              //                   ),
                              //                   // descTextStyle: TextStyle(
                              //                   //   fontWeight: FontWeight.bold,
                              //                   //   fontSize: 20,
                              //                   // ),
                              //                   context: context,
                              //                   animType: AnimType.bottomSlide,
                              //                   headerAnimationLoop: false,
                              //                   dialogType: DialogType.error,
                              //                   showCloseIcon: true,
                              //                   title: "No hubo respuesta del servidor",
                              //                   //desc:"Solicitud enviada",
                              //                   btnOkOnPress: () {
                              //                     //debugPrint('OnClcik');
                              //                   },
                              //                   btnOkColor: Colors.red,
                              //                   btnOkIcon: Icons.check_circle,
                              //                   // onDismissCallback: (type) {
                              //                   //   debugPrint('Dialog Dissmiss from callback $type');
                              //                   // },
                              //                 ).show();
                              //               }
                              //             },
                              //           ).show();
                              //         }, 
                              //       ),
                              //       Expanded(
                              //         child: ListTile(
                              //           // leading: Icon(Icons.person),
                              //           title:Text(horariosInvitado[index]['fecha_salida'], textAlign: TextAlign.center,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                              //           subtitle: Text(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosInvitado[index]['salida'])), textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            },
                            childCount: horariosController.horarios.length,
                            ))
                        ],
                        // child: ListView.builder(
                        //   itemCount: horariosInvitado.length,
                        //   shrinkWrap: true,
                        //   itemBuilder:(context, index) => Container(
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Expanded(
                        //           child: ListTile(
                        //             // leading: Icon(Icons.person),
                        //             title:Text(horariosInvitado[index]['fecha_entrada'], textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        //             subtitle: Text(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosInvitado[index]['entrada'])), textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        //             // trailing: Row(
                        //             //   mainAxisSize: MainAxisSize.min,
                        //             //   children: [
                        //             //     IconButton(
                        //             //     icon: Icon(Icons.edit), 
                        //             //     color: Colors.blue,
                        //             //     onPressed: () {
                        //             //       TimeOfDay prueba = stringToTimeOfDay(horariosInvitado[index]['entrada']);
                        //             //       // var prueba= DateTime.parse(horariosInvitado[index]['fecha_entrada']+" "+horariosInvitado[index]['entrada']);
                        //             //       print(prueba);
                        //             //       print(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosInvitado[index]['entrada'])));
                        //             //     },
                        //             //     ),
                        //             //     SizedBox(width: 10,),
                        //             //     IconButton(
                        //             //       icon: Icon(Icons.delete), color: Colors.red,
                        //             //       onPressed: () async {
                        //             //       }, 
                        //             //     ),
                        //             //   ],
                        //             // ),
                        //             // onTap: () async {
                                
                        //             // },
                        //           ),
                        //         ),
                        //         IconButton(
                        //           iconSize: 40,
                        //           icon: Icon(Icons.delete), color: Colors.red,
                        //           onPressed: () async {
                        //             AwesomeDialog(
                        //               btnCancelText: "NO",
                        //               btnOkText: "SI",
                        //               titleTextStyle: TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 20,
                        //                 color: Colors.black
                        //               ),
                        //               // descTextStyle: TextStyle(
                        //               //   fontWeight: FontWeight.bold,
                        //               //   fontSize: 20,
                        //               //   color: Colors.black
                        //               // ),
                        //               context: context,
                        //               animType: AnimType.bottomSlide,
                        //               headerAnimationLoop: false,
                        //               dialogType: DialogType.warning,
                        //               showCloseIcon: true,
                        //               title: "¿Seguro que desea eliminar el horario?",
                        //               btnCancelOnPress: () {},
                        //               btnOkOnPress: () async {
                        //                 showDialog(
                        //                   // The user CANNOT close this dialog  by pressing outsite it
                        //                   barrierDismissible: false,
                        //                   context: context,
                        //                   builder: (_) {
                        //                     return WillPopScope(
                        //                       onWillPop: () async => false,
                        //                       child: LoadingWidget());
                        //                   }
                        //                 );
                        //                 try {
                        //                   var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                        //                   var res = await client.delete(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${horariosInvitado[index]['id']}/')).timeout(Duration(seconds: 5));
                        //                   //horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                        //                   res = await client.get(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${horariosInvitado[index]['usuario']}/')).timeout(Duration(seconds: 5));
                        //                   //horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                        //                   setState(() {
                        //                     horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                        //                   });
                        //                   Navigator.of(context).pop();
                        //                   AwesomeDialog(
                        //                     titleTextStyle: TextStyle(
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 30,
                        //                       color: Colors.green
                        //                     ),
                        //                     // descTextStyle: TextStyle(
                        //                     //   fontWeight: FontWeight.bold,
                        //                     //   fontSize: 20,
                        //                     // ),
                        //                     context: context,
                        //                     animType: AnimType.topSlide,
                        //                     headerAnimationLoop: false,
                        //                     dialogType: DialogType.success,
                        //                     showCloseIcon: true,
                        //                     title: "¡Horario eliminado con exito!",
                        //                     //desc:"Solicitud enviada",
                        //                     btnOkColor: Colors.green,
                        //                     btnOkOnPress: () {
                        //                       //debugPrint('OnClcik');
                        //                     },
                        //                     btnOkIcon: Icons.check_circle,
                        //                     // onDismissCallback: (type) {
                        //                     //   debugPrint('Dialog Dissmiss from callback $type');
                        //                     // },
                        //                   ).show();
                        //                 } catch (e) {
                        //                   Navigator.of(context).pop();
                        //                   AwesomeDialog(
                        //                     titleTextStyle: TextStyle(
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 30,
                        //                       color: Colors.red
                        //                     ),
                        //                     // descTextStyle: TextStyle(
                        //                     //   fontWeight: FontWeight.bold,
                        //                     //   fontSize: 20,
                        //                     // ),
                        //                     context: context,
                        //                     animType: AnimType.bottomSlide,
                        //                     headerAnimationLoop: false,
                        //                     dialogType: DialogType.error,
                        //                     showCloseIcon: true,
                        //                     title: "No hubo respuesta del servidor",
                        //                     //desc:"Solicitud enviada",
                        //                     btnOkOnPress: () {
                        //                       //debugPrint('OnClcik');
                        //                     },
                        //                     btnOkColor: Colors.red,
                        //                     btnOkIcon: Icons.check_circle,
                        //                     // onDismissCallback: (type) {
                        //                     //   debugPrint('Dialog Dissmiss from callback $type');
                        //                     // },
                        //                   ).show();
                        //                 }
                        //               },
                        //             ).show();
                        //           }, 
                        //         ),
                        //         Expanded(
                        //           child: ListTile(
                        //             // leading: Icon(Icons.person),
                        //             title:Text(horariosInvitado[index]['fecha_salida'], textAlign: TextAlign.center,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        //             subtitle: Text(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(horariosInvitado[index]['salida'])), textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   )
                            
                          // , 
                        // ),
                      );
                    })
                    ):SizedBox(
                        height: 10, 
                       
                      ),
                    SizedBox(
                      height: 40,
                    ),
                    Text("Habilitar/Deshabilitar permiso de apertura con Bluetooth", textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                    SizedBox(
                      height: 10,
                    ),
                    // SwitchListTile(
                    //   title: const Text('DATOS', style: TextStyle(fontSize: 30),),
                    //   value: datosInvitado['internet'],
                    //   onChanged: (bool value) async {
                    //     showDialog(
                    //       // The user CANNOT close this dialog  by pressing outsite it
                    //       barrierDismissible: false,
                    //       context: context,
                    //       builder: (_) {
                    //         return WillPopScope(
                    //           onWillPop: () async => false,
                    //           child: LoadingWidget());
                    //       }
                    //     );
                    //     try {
                    //       Map jsonUsuario={"telefonoInternet":value.toString()};
                    //       var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                    //       var res = await client.put(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${datosInvitado['id']}/blank/blank/'), body: jsonUsuario).timeout(Duration(seconds: 5));
                    //       //print(res.body);
                    //       var dataUsuario = await jsonDecode(res.body);
                          
                    //       setState(() {
                    //         datosInvitado['internet'] = value;
                    //       });
                    //       Navigator.of(context).pop();
                    //       AwesomeDialog(
                    //         titleTextStyle: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 30,
                    //           color: Colors.green
                    //         ),
                    //         // descTextStyle: TextStyle(
                    //         //   fontWeight: FontWeight.bold,
                    //         //   fontSize: 20,
                    //         // ),
                    //         context: context,
                    //         animType: AnimType.topSlide,
                    //         headerAnimationLoop: false,
                    //         dialogType: DialogType.success,
                    //         showCloseIcon: true,
                    //         title: "¡Permiso de uso de servicio cambiado con exito!",
                    //         //desc:"Solicitud enviada",
                    //         btnOkColor: Colors.green,
                    //         btnOkOnPress: () {
                    //           //debugPrint('OnClcik');
                    //         },
                    //         btnOkIcon: Icons.check_circle,
                    //         // onDismissCallback: (type) {
                    //         //   debugPrint('Dialog Dissmiss from callback $type');
                    //         // },
                    //       ).show();
                    //     } catch (e) {
                    //       Navigator.of(context).pop();
                    //       AwesomeDialog(
                    //         titleTextStyle: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 30,
                    //           color: Colors.red
                    //         ),
                    //         // descTextStyle: TextStyle(
                    //         //   fontWeight: FontWeight.bold,
                    //         //   fontSize: 20,
                    //         // ),
                    //         context: context,
                    //         animType: AnimType.bottomSlide,
                    //         headerAnimationLoop: false,
                    //         dialogType: DialogType.error,
                    //         showCloseIcon: true,
                    //         title: "No hubo respuesta del servidor",
                    //         //desc:"Solicitud enviada",
                    //         btnOkOnPress: () {
                    //           //debugPrint('OnClcik');
                    //         },
                    //         btnOkColor: Colors.red,
                    //         btnOkIcon: Icons.check_circle,
                    //         // onDismissCallback: (type) {
                    //         //   debugPrint('Dialog Dissmiss from callback $type');
                    //         // },
                    //       ).show();
                    //     }
                        
                    //   },
                    //   //secondary: const Icon(Icons.lightbulb_outline),
                    // ),
                    // SwitchListTile(
                    //   title: const Text('WIFI (Proximidad)', style: TextStyle(fontSize: 25),),
                    //   value: datosInvitado['wifi'],
                    //   onChanged: (bool value) async {
                    //     showDialog(
                    //       // The user CANNOT close this dialog  by pressing outsite it
                    //       barrierDismissible: false,
                    //       context: context,
                    //       builder: (_) {
                    //         return WillPopScope(
                    //           onWillPop: () async => false,
                    //           child: LoadingWidget());
                    //       }
                    //     );
                    //     try {
                    //       Map jsonUsuario={"telefonoWifi":value.toString()};
                    //       var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                    //       var res = await client.put(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${datosInvitado['id']}/blank/blank/'), body: jsonUsuario).timeout(Duration(seconds: 5));
                    //       var dataUsuario = await jsonDecode(res.body);
                    //        setState(() {
                    //         datosInvitado['wifi'] = value;
                    //       });
                    //       Navigator.of(context).pop();
                    //       AwesomeDialog(
                    //         titleTextStyle: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 30,
                    //           color: Colors.green
                    //         ),
                    //         // descTextStyle: TextStyle(
                    //         //   fontWeight: FontWeight.bold,
                    //         //   fontSize: 20,
                    //         // ),
                    //         context: context,
                    //         animType: AnimType.topSlide,
                    //         headerAnimationLoop: false,
                    //         dialogType: DialogType.success,
                    //         showCloseIcon: true,
                    //         title: "¡Permiso de uso de servicio cambiado con exito!",
                    //         //desc:"Solicitud enviada",
                    //         btnOkColor: Colors.green,
                    //         btnOkOnPress: () {
                    //           //debugPrint('OnClcik');
                    //         },
                    //         btnOkIcon: Icons.check_circle,
                    //         // onDismissCallback: (type) {
                    //         //   debugPrint('Dialog Dissmiss from callback $type');
                    //         // },
                    //       ).show();
                    //     } catch (e) {
                    //       Navigator.of(context).pop();
                    //       AwesomeDialog(
                    //         titleTextStyle: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 30,
                    //           color: Colors.red
                    //         ),
                    //         // descTextStyle: TextStyle(
                    //         //   fontWeight: FontWeight.bold,
                    //         //   fontSize: 20,
                    //         // ),
                    //         context: context,
                    //         animType: AnimType.bottomSlide,
                    //         headerAnimationLoop: false,
                    //         dialogType: DialogType.error,
                    //         showCloseIcon: true,
                    //         title: "No hubo respuesta del servidor",
                    //         //desc:"Solicitud enviada",
                    //         btnOkOnPress: () {
                    //           //debugPrint('OnClcik');
                    //         },
                    //         btnOkColor: Colors.red,
                    //         btnOkIcon: Icons.check_circle,
                    //         // onDismissCallback: (type) {
                    //         //   debugPrint('Dialog Dissmiss from callback $type');
                    //         // },
                    //       ).show();
                    //     }

                    //   },
                    //   //secondary: const Icon(Icons.lightbulb_outline),
                    // ),
                    SwitchListTile(
                      title: const Text('BLUETOOTH', style: TextStyle(fontSize: 28),),
                      value: datosInvitado['bluetooth'],
                      onChanged: (bool value) async{
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
                          Map jsonUsuario={"telefonoBluetooth":value.toString()};
                          var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                          var res = await client.put(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${datosInvitado['id']}/blank/blank/'), body: jsonUsuario).timeout(Duration(seconds: 5));
                          var dataUsuario = await jsonDecode(res.body);
                          setState(() {
                            datosInvitado['bluetooth'] = value;
                            });
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
                            animType: AnimType.topSlide,
                            headerAnimationLoop: false,
                            dialogType: DialogType.success,
                            showCloseIcon: true,
                            title: "¡Se ha cambiado el permiso de apertura con bluetooth!",
                            //desc:"Solicitud enviada",
                            btnOkColor: Colors.green,
                            btnOkOnPress: () {
                              //debugPrint('OnClcik');
                            },
                            btnOkIcon: Icons.check_circle,
                            // onDismissCallback: (type) {
                            //   debugPrint('Dialog Dissmiss from callback $type');
                            // },
                          ).show();
                        } catch (e) {
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

                      },
                    ),
                    ],
                  )
                )
                :LoadingWidget(),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: FloatingActionButton( 
      //     child: Icon(Icons.arrow_back_rounded, size: 40,),  
      //     onPressed: (() {
      //       widget.volver(0);
      //     }),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    )
  );
}