import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/controllers/visitantes_controller.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/services.dart';

typedef void ScreenCallback(int id);

class VerInvitadosScreen extends StatefulWidget {
  // final ScreenCallback volver;
  // VerInvitadosScreen({required this.volver});

  @override
  State<VerInvitadosScreen> createState() => _VerInvitadosScreenState();
}

class _VerInvitadosScreenState extends State<VerInvitadosScreen> {

  ScreensVisitantesController controller = Get.find();
  VisitantesController visitantesController = Get.find();

  Map datosUsuario={};
  List invitados=[];
  String linkAndroid='https://webseguricel.up.railway.app/inicio';
  String linkIOS='https://webseguricel.up.railway.app/inicio';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerInvitados();
  }

  obtenerInvitados() async {

    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    String encodeDatosInvitados = await Constants.prefs.getString('datosInvitados').toString();
    //print(idUsuario);

    // print(encodeDatosUsuario);
    // print(encodeContratos);
    // print(encodeAccesos);
    setState (() {
      datosUsuario= jsonDecode(encodeDatosUsuario);
      invitados= (jsonDecode(encodeDatosInvitados) as List<dynamic>).cast<Map>();
      visitantesController.cambiarVisitantes(invitados);
      
    });
    //print(invitados);
    try {

      var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
      var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${datosUsuario['contrato_id']}/${datosUsuario['cedula']}/Visitante/')).timeout(Duration(seconds: 5));
      var actualizarInvitados = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
      if (res.body!=encodeDatosInvitados){
        await Constants.prefs.setString('datosInvitados', res.body);
        visitantesController.cambiarVisitantes(actualizarInvitados);
        // setState(() {
        //   invitados=actualizarInvitados;
        // });
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      controller.cambiarScreen(0);
      // widget.volver(0);
      return false;
    },
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              GetBuilder<VisitantesController>(builder: (VisitantesController){ 
                return Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    (datosUsuario!={} && VisitantesController.visitantes.length==0)
                    ?SizedBox(height:30)
                    :Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Mis invitados', 
                          textAlign: TextAlign.center, 
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SpeedDial(
                          direction: SpeedDialDirection.down,
                          spacing: 10,
                          spaceBetweenChildren: 10,
                          childMargin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          childPadding: EdgeInsets.symmetric(vertical: 0),
                          icon: Icons.menu, //icon on Floating action button
                          activeIcon: Icons.close, //icon when menu is expanded on button
                          backgroundColor: Color.fromARGB(255, 255, 149, 62), //background color of button
                          foregroundColor: Colors.white, //font color, icon color in button
                          activeBackgroundColor: Color.fromARGB(255, 45, 94, 255), //background color when menu is expanded
                          activeForegroundColor: Colors.white,
                          buttonSize: Size(50.0,50.0),
                          childrenButtonSize: const Size(50.0, 50.0), //button size
                          visible: true,
                          closeManually: false,
                          curve: Curves.bounceIn,
                          overlayColor: Colors.black,
                          overlayOpacity: 0.5,
                          // onOpen: () => print('OPENING DIAL'), // action when menu opens
                          // onClose: () => print('DIAL CLOSED'), //action when menu closes
                          elevation: 8.0, //shadow elevation of button
                          shape: CircleBorder(), //shape of button
                          
                          children: [
                            SpeedDialChild( //speed dial child
                              child: Icon(Icons.delete_forever),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              label: 'Eliminar invitados',
                              labelStyle: TextStyle(fontSize: 20.0),
                              onTap: () => Get.toNamed("/eliminarinvitados"),
                              // onLongPress: () => print('FIRST CHILD LONG PRESS'),
                            ),

                            //add more menu item children here
                          ],
                        ),
                        
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    (datosUsuario=={})
                    ?LoadingWidget()
                    :(datosUsuario!={} && VisitantesController.visitantes.length==0)
                    ?Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Text('Actualmente no tiene invitados', 
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                    :Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 240, 162, 73),
                          width: 3,
                        )
                      ),
                    child: ListView.builder(
                      // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemCount: VisitantesController.visitantes.length,
                      shrinkWrap: true,
                      itemBuilder:(_, index) => Container(
                        child: ListTile(
                          // leading: Icon(Icons.person),
                          title:Text("${VisitantesController.visitantes[index]['nombre']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          subtitle: Text("Codigo: ${VisitantesController.visitantes[index]['telegram_id']}"),
                          onTap: () async {
                            //print(invitados[index]);
                                String datosInvitado=jsonEncode({'internet':VisitantesController.visitantes[index]['telefonoInternet'], 'wifi':VisitantesController.visitantes[index]['telefonoWifi'], 'bluetooth':VisitantesController.visitantes[index]['telefonoBluetooth'],'nombre':VisitantesController.visitantes[index]['nombre'], 'codigo':VisitantesController.visitantes[index]['telegram_id'], 'cedula':VisitantesController.visitantes[index]['cedula'], 'id':VisitantesController.visitantes[index]['id'], 'contrato_id':VisitantesController.visitantes[index]['contrato'], 'cedula_propietario':VisitantesController.visitantes[index]['cedula_propietario']});
                               
                                await Constants.prefs.setString('datosInvitadoEditar', datosInvitado);
                                //print(datosInvitado);
                                controller.cambiarScreen(6);
                                // widget.volver(6);
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // IconButton(
                              // icon: Icon(Icons.edit), 
                              // color: Colors.blue,
                              // onPressed: () async {
                              //   //print(invitados[index]);
                              //   String datosInvitado=jsonEncode({'internet':invitados[index]['telefonoInternet'], 'wifi':invitados[index]['telefonoWifi'], 'bluetooth':invitados[index]['telefonoBluetooth'],'nombre':invitados[index]['nombre'], 'codigo':invitados[index]['telegram_id'], 'cedula':invitados[index]['cedula'], 'id':invitados[index]['id'], 'contrato_id':invitados[index]['contrato'], 'cedula_propietario':invitados[index]['cedula_propietario']});
                               
                              //   await Constants.prefs.setString('datosInvitadoEditar', datosInvitado);
                              //   //print(datosInvitado);
                              //   controller.cambiarScreen(6);
                              //   // widget.volver(6);
                              // },
                              // ),
                              // SizedBox(width: 10,),
                              IconButton(
                                icon: Icon(Icons.content_copy_outlined), color: Color.fromARGB(255, 255, 153, 58),
                                onPressed: () async {
                                  String textoCopiar="Informacion de invitado\n\nNombre: ${VisitantesController.visitantes[index]['nombre']}\nCodigo: ${VisitantesController.visitantes[index]['telegram_id']}\n\nSi desea abrir con su telefono por proximidad via Bluetooth, descargue la aplicacion.\n\nAndroid: ${linkAndroid}\n\niOs: ${linkIOS}";
                                  Clipboard.setData(new ClipboardData(text: textoCopiar)).then((_){
                                    ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Informacion de invitado copiada')));
                                  });




                                //   AwesomeDialog(
                                //     btnCancelText: "NO",
                                //     btnOkText: "SI",
                                //     titleTextStyle: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20,
                                //       color: Colors.black
                                //     ),
                                //     // descTextStyle: TextStyle(
                                //     //   fontWeight: FontWeight.bold,
                                //     //   fontSize: 20,
                                //     //   color: Colors.black
                                //     // ),
                                //     context: context,
                                //     animType: AnimType.bottomSlide,
                                //     headerAnimationLoop: false,
                                //     dialogType: DialogType.warning,
                                //     showCloseIcon: true,
                                //     title: "¿Seguro que desea eliminar al invitado ${invitados[index]['nombre']}?",
                                //     btnCancelOnPress: () {},
                                //     btnOkOnPress: () async {
                                //       bool cerrarLoading=false;
                                //       showDialog(
                                //         // The user CANNOT close this dialog  by pressing outsite it
                                //         barrierDismissible: false,
                                //         context: _,
                                //         builder: (_) {
                                //           return WillPopScope(
                                //             onWillPop: () async => false,
                                //             child: LoadingWidget());
                                //         }
                                //       );
                                //       try {
                                //         var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                                //         var res = await client.delete(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${invitados[index]['id']}/blank/blank/')).timeout(Duration(seconds: 5));
                                //         var data = await jsonDecode(res.body);
                                //         // print(data);
                                //         if(res.statusCode==200){
                                //           setState(() {
                                //           invitados.removeAt(index);
                                //         });
                                //         var invitadosEncode = await jsonEncode(invitados);
                                //         await Constants.prefs.setString('datosInvitados', invitadosEncode);
                                //         cerrarLoading=true;
                                //         Navigator.of(context).pop();
                                //         AwesomeDialog(
                                //           titleTextStyle: TextStyle(
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 30,
                                //             color: Colors.green
                                //           ),
                                //           // descTextStyle: TextStyle(
                                //           //   fontWeight: FontWeight.bold,
                                //           //   fontSize: 20,
                                //           // ),
                                //           context: context,
                                //           animType: AnimType.topSlide,
                                //           headerAnimationLoop: false,
                                //           dialogType: DialogType.success,
                                //           showCloseIcon: true,
                                //           title: "¡Invitado eliminado con exito!",
                                //           //desc:"Solicitud enviada",
                                //           btnOkColor: Colors.green,
                                //           btnOkOnPress: () {
                                //             //debugPrint('OnClcik');
                                //           },
                                //           btnOkIcon: Icons.check_circle,
                                //           // onDismissCallback: (type) {
                                //           //   debugPrint('Dialog Dissmiss from callback $type');
                                //           // },
                                //         ).show();
                                //         }
                                //       } catch (e) {
                                //         if (cerrarLoading==false){
                                //           Navigator.of(context).pop();
                                //         }
                                //         AwesomeDialog(
                                //           titleTextStyle: TextStyle(
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 30,
                                //             color: Colors.red
                                //           ),
                                //           // descTextStyle: TextStyle(
                                //           //   fontWeight: FontWeight.bold,
                                //           //   fontSize: 20,
                                //           // ),
                                //           context: context,
                                //           animType: AnimType.bottomSlide,
                                //           headerAnimationLoop: false,
                                //           dialogType: DialogType.error,
                                //           showCloseIcon: true,
                                //           title: "No hubo respuesta del servidor",
                                //           //desc:"Solicitud enviada",
                                //           btnOkOnPress: () {
                                //             //debugPrint('OnClcik');
                                //           },
                                //           btnOkColor: Colors.red,
                                //           btnOkIcon: Icons.check_circle,
                                //           // onDismissCallback: (type) {
                                //           //   debugPrint('Dialog Dissmiss from callback $type');
                                //           // },
                                //         ).show();
                                //       }
                                //     },
                                //   ).show();
                                }, 
                              ),
                              
                              // IconButton(
                              //   icon: Icon(Icons.delete), color: Colors.red,
                              //   onPressed: () async {
                              //     AwesomeDialog(
                              //       btnCancelText: "NO",
                              //       btnOkText: "SI",
                              //       titleTextStyle: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 20,
                              //         color: Colors.black
                              //       ),
                              //       // descTextStyle: TextStyle(
                              //       //   fontWeight: FontWeight.bold,
                              //       //   fontSize: 20,
                              //       //   color: Colors.black
                              //       // ),
                              //       context: context,
                              //       animType: AnimType.bottomSlide,
                              //       headerAnimationLoop: false,
                              //       dialogType: DialogType.warning,
                              //       showCloseIcon: true,
                              //       title: "¿Seguro que desea eliminar al invitado ${invitados[index]['nombre']}?",
                              //       btnCancelOnPress: () {},
                              //       btnOkOnPress: () async {
                              //         bool cerrarLoading=false;
                              //         showDialog(
                              //           // The user CANNOT close this dialog  by pressing outsite it
                              //           barrierDismissible: false,
                              //           context: _,
                              //           builder: (_) {
                              //             return WillPopScope(
                              //               onWillPop: () async => false,
                              //               child: LoadingWidget());
                              //           }
                              //         );
                              //         try {
                              //           var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                              //           var res = await client.delete(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${invitados[index]['id']}/blank/blank/')).timeout(Duration(seconds: 5));
                              //           var data = await jsonDecode(res.body);
                              //           // print(data);
                              //           if(res.statusCode==200){
                              //             setState(() {
                              //             invitados.removeAt(index);
                              //           });
                              //           var invitadosEncode = await jsonEncode(invitados);
                              //           await Constants.prefs.setString('datosInvitados', invitadosEncode);
                              //           cerrarLoading=true;
                              //           Navigator.of(context).pop();
                              //           AwesomeDialog(
                              //             titleTextStyle: TextStyle(
                              //               fontWeight: FontWeight.bold,
                              //               fontSize: 30,
                              //               color: Colors.green
                              //             ),
                              //             // descTextStyle: TextStyle(
                              //             //   fontWeight: FontWeight.bold,
                              //             //   fontSize: 20,
                              //             // ),
                              //             context: context,
                              //             animType: AnimType.topSlide,
                              //             headerAnimationLoop: false,
                              //             dialogType: DialogType.success,
                              //             showCloseIcon: true,
                              //             title: "¡Invitado eliminado con exito!",
                              //             //desc:"Solicitud enviada",
                              //             btnOkColor: Colors.green,
                              //             btnOkOnPress: () {
                              //               //debugPrint('OnClcik');
                              //             },
                              //             btnOkIcon: Icons.check_circle,
                              //             // onDismissCallback: (type) {
                              //             //   debugPrint('Dialog Dissmiss from callback $type');
                              //             // },
                              //           ).show();
                              //           }
                              //         } catch (e) {
                              //           if (cerrarLoading==false){
                              //             Navigator.of(context).pop();
                              //           }
                              //           AwesomeDialog(
                              //             titleTextStyle: TextStyle(
                              //               fontWeight: FontWeight.bold,
                              //               fontSize: 30,
                              //               color: Colors.red
                              //             ),
                              //             // descTextStyle: TextStyle(
                              //             //   fontWeight: FontWeight.bold,
                              //             //   fontSize: 20,
                              //             // ),
                              //             context: context,
                              //             animType: AnimType.bottomSlide,
                              //             headerAnimationLoop: false,
                              //             dialogType: DialogType.error,
                              //             showCloseIcon: true,
                              //             title: "No hubo respuesta del servidor",
                              //             //desc:"Solicitud enviada",
                              //             btnOkOnPress: () {
                              //               //debugPrint('OnClcik');
                              //             },
                              //             btnOkColor: Colors.red,
                              //             btnOkIcon: Icons.check_circle,
                              //             // onDismissCallback: (type) {
                              //             //   debugPrint('Dialog Dissmiss from callback $type');
                              //             // },
                              //           ).show();
                              //         }
                              //       },
                              //     ).show();
                              //   }, 
                              // ),
                            ],
                          ),
                          // onTap: () async {

                          // },
                        ),
                      )
                        
                      , 
                    ),
                  ),
                  ],
                )
              );
            })
            ],
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