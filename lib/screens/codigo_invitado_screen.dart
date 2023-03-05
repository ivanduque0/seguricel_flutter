import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/controllers/codigo_visitante_controller.dart';
import 'package:seguricel_flutter/screens/editarinvitado_screen.dart';
import 'package:seguricel_flutter/screens/seleccionarinvitado_screen.dart';
import 'package:seguricel_flutter/screens/verinvitados_screen.dart';

import 'package:get/get.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

// class InvitadosScreen extends StatefulWidget {
//   const InvitadosScreen({super.key});

//   @override
//   State<InvitadosScreen> createState() => _InvitadosScreenState();
// }

class InvitadosScreen extends StatelessWidget {
  int screen=0;
  final _formKey = GlobalKey<FormState>();

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
                  Text("Ingrese el codigo del invitado", textAlign: TextAlign.center,
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
                        keyboardType: TextInputType.text,
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
                    child: ElevatedButton(
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
                            var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                            var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/sesionappapi//')).timeout(Duration(seconds: 5));
                            var sesiondata = await jsonDecode(res.body);
                          
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
                      child: Text("Buscar", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                      ),
                    )
                  ),
                  ],
              );}):ScreensVisitantesController.visitanteScreen==1?VerInvitadosScreen()
              :ScreensVisitantesController.visitanteScreen==4?SeleccionarInvitadoScreen()
              :EditarInvitadosScreen()
      
            ),
          ),
        ),
      );
    },);
  
  }
}