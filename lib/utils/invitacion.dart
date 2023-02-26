import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/controllers/horarios_controller.dart';
import 'package:seguricel_flutter/utils/loading.dart';

class Invitacion extends StatelessWidget {
  
  Invitacion({super.key, required this.fecha_entrada, required this.fecha_salida, required this.hora_entrada, required this.hora_salida, required this.horario_id, required this.usuario_id, required this.acompanantes});

  final fecha_entrada;
  final fecha_salida;
  final hora_entrada;
  final hora_salida;
  final horario_id;
  final usuario_id;
  final acompanantes;
  
  HorariosController horariosController = Get.put(HorariosController());


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        //height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width/1.3,
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 195, 145),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21)
                  )
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Acompañantes: ${acompanantes}", 
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          iconSize: 30,
                          onPressed: () async {
                            AwesomeDialog(
                              btnCancelText: "NO",
                              btnOkText: "SI",
                              titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                              title: "¿Seguro que desea eliminar el horario?",
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
                                  var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                                  var res = await client.delete(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${horario_id}/')).timeout(Duration(seconds: 5));
                                  //horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                                  res = await client.get(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${usuario_id}/')).timeout(Duration(seconds: 5));
                                  List horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
                                  int index = horariosController.horarios.indexWhere(((horario) => horario['id'] == horario_id));
                                  // print(index);
                                  // print(horariosController.horarios);
                                  horariosController.horarios.removeAt(index);
                                  // print(horariosController.horarios);
                                  //horariosController.cambiarhorarios(horariosInvitado);
                                  //horariosInvitado = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
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
                                    title: "¡Horario eliminado con exito!",
                                    //desc:"Solicitud enviada",
                                    btnOkColor: Colors.green,
                                    btnOkOnPress: () {
                                      
                                      //debugPrint('OnClcik');
                                    },
                                    btnOkIcon: Icons.check_circle,
                                    onDismissCallback: (type) {
                                      horariosController.cambiarhorarios(horariosInvitado);
                                      //debugPrint('Dialog Dissmiss from callback $type');
                                    },
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
                            ).show();
                          },
                          // padding: EdgeInsets.all(0),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                          )
                        )
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder:(BuildContext context, BoxConstraints constraints) {
                          return Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            direction: Axis.horizontal,
                            children: List.generate(
                              (constraints.constrainWidth()/15).floor(), (index) => SizedBox(
                                width: 5, height: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                  )
                                ),
                              )
                            ),
                          );
                        },
                      )
                    ),
                    SizedBox(
                      height: 20,
                      width: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)
                          )
                        )
                      ),
                    )
                  ],
                )
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21)
                  )
                ),
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Entrada", 
                          style: TextStyle(
                            color: Colors.orange.shade200,
                            fontSize: 20
                          ),
                        ),
                        Text("Salida", 
                          style: TextStyle(
                            color: Colors.orange.shade200,
                            fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fecha_entrada, 
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(fecha_salida, 
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(hora_entrada, 
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(hora_salida, 
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}