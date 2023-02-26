import 'package:flutter/material.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/controllers/visitantes_controller.dart';
import 'package:seguricel_flutter/screens/crearnuevoinvitado_screen.dart';
import 'package:seguricel_flutter/screens/editarinvitado_screen.dart';
import 'package:seguricel_flutter/screens/personalizartiempoinvitado_screen.dart';
import 'package:seguricel_flutter/screens/seleccionarinvitado_screen.dart';
import 'package:seguricel_flutter/screens/seleccionarinvitadoexistente_screen.dart';
import 'package:seguricel_flutter/screens/tiempoinvitado_screen.dart';
import 'package:seguricel_flutter/screens/verinvitados_screen.dart';

import 'package:get/get.dart';

// class InvitadosScreen extends StatefulWidget {
//   const InvitadosScreen({super.key});

//   @override
//   State<InvitadosScreen> createState() => _InvitadosScreenState();
// }

class InvitadosScreen extends StatelessWidget {
  int screen=0;

  // void updateScreen(int newScreen) {
  //   setState(() {
  //     screen = newScreen;
  //   });
  // }

  ScreensVisitantesController controller = Get.put(ScreensVisitantesController());
  VisitantesController visitantesController = Get.put(VisitantesController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScreensVisitantesController>(builder: (ScreensVisitantesController){
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ScreensVisitantesController.visitanteScreen==0?Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text("Configuracion de visitantes", textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    //Navigator.pushNamed(context, EntrarPage.routeName);
                  }, // Handle your callback.
                  splashColor: Color.fromARGB(255, 255, 175, 110).withOpacity(0.5),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                    fixedSize: Size(220, 100),
                    foregroundColor: Colors.orange[300],
                    //disabledForegroundColor: Colors.red,
                    side: BorderSide(color: Colors.orange, width: 3),
                  ),
                    onPressed: (() {
                      controller.cambiarScreen(1);
                      // setState(() {
                      //   screen=1;
                      //   // print("state 3");
                      // });
                    }), 
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/3,
                      child: Center(
                        child: Text("Mis\ninvitados", textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40),),
                      ),
                      // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20)
                        
                      // ),
                    ),
                  ),
                  // Ink(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height/3,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     image: DecorationImage(
                  //       image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    //Navigator.pushNamed(context, EntrarPage.routeName);
                  }, // Handle your callback.
                  splashColor: Color.fromARGB(255, 175, 255, 110).withOpacity(0.5),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                    fixedSize: Size(220, 100),
                    foregroundColor: Colors.green[300],
                    //disabledForegroundColor: Colors.red,
                    side: BorderSide(color: Colors.green, width: 3),
                  ),
                    onPressed: (() {
                      controller.cambiarScreen(2);
                    // setState(() {
                    //     screen=2;
                    //     // print("state 3");
                    //   });
                    }), 
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/3,
                      child: Center(
                        child: Text("Crear\ninvitacion", textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40),),
                      ),
                      // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20)
                        
                      // ),
                    ),
                  ),
                  // Ink(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height/3,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     image: DecorationImage(
                  //       image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                ),
              ],
            ):ScreensVisitantesController.visitanteScreen==1?VerInvitadosScreen()
            :ScreensVisitantesController.visitanteScreen==2?TiempoInvitadoScreen()
            :ScreensVisitantesController.visitanteScreen==3?PersonalizarTiempoInvitadoScreen()
            :ScreensVisitantesController.visitanteScreen==4?SeleccionarInvitadoScreen()
            :ScreensVisitantesController.visitanteScreen==5?CrearNuevoInvitadoScreen()
            :ScreensVisitantesController.visitanteScreen==6?EditarInvitadosScreen()
            :SeleccionarInvitadoExistenteScreen()

          ),
        ),
      );
    },);
  
  }
}