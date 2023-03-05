import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/controllers/screens_unidad_controller.dart';
import 'package:seguricel_flutter/controllers/codigo_unidad_controller.dart';
import 'package:seguricel_flutter/screens/editarinvitado_screen.dart';
import 'package:seguricel_flutter/screens/motivo_apertura_screen.dart';
import 'package:seguricel_flutter/screens/seleccionarinvitado_screen.dart';
import 'package:seguricel_flutter/screens/personas_unidad_screen.dart';

import 'package:get/get.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

// class CodigoUnidadScreen extends StatefulWidget {
//   const CodigoUnidadScreen({super.key});

//   @override
//   State<CodigoUnidadScreen> createState() => _CodigoUnidadScreenState();
// }

class CodigoUnidadScreen extends StatelessWidget {
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
    return GetBuilder<ScreensUnidadController>(builder: (ScreensUnidadController){
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ScreensUnidadController.unidadScreen==0
            ?GetBuilder<CodigoUnidadController>(builder: (CodigoUnidadController){
              return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ingrese el codigo de la unidad", textAlign: TextAlign.center,
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
                      initialValue: CodigoUnidadController.codigo==""?null:CodigoUnidadController.codigo,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "Ingrese un codigo",
                        labelText: "Codigo"
                      ),
                      onChanged: (value) {
                        CodigoUnidadController.cambiarCodigo(value);
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
                    onPressed:(CodigoUnidadController.codigo=="")? null : () async {
                      ScreensUnidadController.cambiarScreen(1);
                    },
                    child: Text("Continuar", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                    ),
                  )
                ),
                ],
            );}):ScreensUnidadController.unidadScreen==1?PersonasUnidadScreen()
            :ScreensUnidadController.unidadScreen==2?AperturasScreen()
            :ScreensUnidadController.unidadScreen==4?SeleccionarInvitadoScreen()
            :EditarInvitadosScreen()

      
          ),
        ),
      );
    },);
  
  }
}