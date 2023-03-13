import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/controllers/codigo_visitante_controller.dart';
import 'package:seguricel_flutter/screens/motivo_apertura_screen.dart';
import 'package:seguricel_flutter/controllers/apertura_visitante_controller.dart';
import 'package:seguricel_flutter/controllers/personas_visitante_controller.dart';
import 'package:seguricel_flutter/controllers/contrato_controller.dart';
import 'package:get/get.dart';
import 'package:seguricel_flutter/utils/loading.dart';

// class InvitadosScreen extends StatefulWidget {
//   const InvitadosScreen({super.key});

//   @override
//   State<InvitadosScreen> createState() => _InvitadosScreenState();
// }

class InvitadosScreen extends StatelessWidget {
  int screen=0;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _codeController = TextEditingController();
  AperturaVisitanteController aperturaVisitanteController = Get.find();
  PersonasVisitanteController personasVisitanteController = Get.find();
  ContratoController contratoController = Get.find();

  // void updateScreen(int newScreen) {
  //   setState(() {
  //     screen = newScreen;
  //   });
  // }

  // ScreensVisitantesController controller = Get.put(ScreensVisitantesController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScreensVisitantesController>(builder: (ScreensVisitantesController){
      return SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ScreensVisitantesController.visitanteScreen==0
              ?GetBuilder<CodigoVisitanteController>(builder: (CodigoVisitanteController){
                return Column(
                children: [
                  Text("Ingrese el codigo de invitacion", textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: "Ingrese un codigo",
                          labelText: "Codigo"
                        ),
                        onChanged: (value) {
                          CodigoVisitanteController.cambiarCodigo(value);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: GetBuilder<ContratoController>(builder: (ContratoController){
                      return ElevatedButton(
                      onPressed:(CodigoVisitanteController.codigo=="")? null : () async {
                        if (_formKey.currentState!.validate()) {
                          
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
                            //print('https://webseguricel.up.railway.app/obtenerinvitacionvigilanteapi/${CodigoVisitanteController.codigo}/${ContratoController.contrato}/');
                            var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                            var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/obtenerinvitacionvigilanteapi/${CodigoVisitanteController.codigo}/${ContratoController.contrato}/')).timeout(Duration(seconds: 5));
                            var horariodata = await jsonDecode(res.body);
                            //print(horariodata);
                            res=await client.get(Uri.parse('https://webseguricel.up.railway.app/obtenerusuariovigilanteapi/${horariodata['usuario']}/')).timeout(Duration(seconds: 5));
                            var usuariodata = await jsonDecode(res.body);
                            //print(usuariodata);
                            Navigator.of(context).pop();
                            showDialog(
                            // The user CANNOT close this dialog  by pressing outsite it
                            barrierDismissible: true,
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.all(10),
                                child: Container(
                                  width: double.infinity,
                                  height: 350,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(255, 255, 255, 255)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Text("Nombre: ${usuariodata['nombre']}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: Text("Cedula: ${usuariodata['cedula']}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 20),
                                          child: Text("Acompañantes: ${horariodata['acompanantes']}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            height: 100,
                                            width: 180,
                                            child: ElevatedButton(
                                              onPressed: (){
                                                _codeController.clear();
                                                personasVisitanteController.cambiarpersonas(horariodata['acompanantes'].toString());
                                                aperturaVisitanteController.cambiarVisitante(true);
                                                Navigator.of(context).pop();
                                                ScreensVisitantesController.cambiarScreen(1);
                                              }, 
                                              child: Text("Continuar", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // child: Stack(
                                //   clipBehavior: Clip.none,
                                //   alignment: Alignment.center,
                                //   children: <Widget>[
                                //     Container(
                                //       width: double.infinity,
                                //       height: 200,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(15),
                                //         color: Colors.lightBlue
                                //       ),
                                //       padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                                //       child: Text("You can make cool stuff!",
                                //         style: TextStyle(fontSize: 24),
                                //         textAlign: TextAlign.center
                                //       ),
                                //     ),
                                //     // Positioned(
                                //     //   top: -100,
                                //     //   child: Image.network("https://i.imgur.com/2yaf2wb.png", width: 150, height: 150)
                                //     // )
                                //   ],
                                // )
                              );
                              // return Card(
                              //   child: Column(
                              //     children: [
                              //       ListTile(
                              //         title: Text("Nombre"),
                              //         subtitle: Text(usuariodata[0]['nombre']),
                              //       ),
                              //       ListTile(
                              //         title: Text("Cedula"),
                              //         subtitle: Text(usuariodata[0]['cedula']),
                              //       ),
                              //       ElevatedButton(
                              //         onPressed: (){
                              //           print("ABRIR");
                              //         }, 
                              //         child: Text("ABRIR", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              //         style: ElevatedButton.styleFrom(
                              //           backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // );
                            }
                          );
                          
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
                        }
                      },
                      child: Text("Verificar", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                      ),
                    );})
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed("/qrscanner");
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const BarcodeScannerWithController(),
                        //   ),
                        // );
                      },
                      child: Text("Escanear QR", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 14, 78, 255), // Background color
                        ),
                    ),
                  ),
                  ],
              );}):AperturasScreen()
      
            ),
          ),
        ),
      );
    },);
  
  }
}