import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seguricel_flutter/controllers/screens_unidad_controller.dart';
import 'package:seguricel_flutter/controllers/personas_unidad_controller.dart';
import 'package:get/get.dart';

// class CodigoUnidadScreen extends StatefulWidget {
//   const CodigoUnidadScreen({super.key});

//   @override
//   State<CodigoUnidadScreen> createState() => _CodigoUnidadScreenState();
// }

class PersonasUnidadScreen extends StatelessWidget {
  int screen=0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _codeController = TextEditingController();
  PersonasUnidadController personasUnidadController = Get.find();
  ScreensUnidadController screensUnidadController = Get.find();

  // void updateScreen(int newScreen) {
  //   setState(() {
  //     screen = newScreen;
  //   });
  // }

  // ScreensVisitantesController controller = Get.put(ScreensVisitantesController());

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      screensUnidadController.cambiarScreen(0);
      // widget.volver(1);
      return false;
    },
    child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text("Ingrese la cantidad de personas", textAlign: TextAlign.center,
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
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: "Ingrese una cantidad",
                          // labelText: ""
                        ),
                        onChanged: (value) {
                          personasUnidadController.cambiarpersonas(value);
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
                    child: GetBuilder<PersonasUnidadController>(builder: (PersonasUnidadController){
                      return ElevatedButton(
                      onPressed:(PersonasUnidadController.personas=="")? null : () async {
                        screensUnidadController.cambiarScreen(2);
                      },
                      child: Text("Continuar", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                      ),
                    );})
                  ),
                  ],
              )
      
            ),
          ),
        ),
      )
  
  );
}