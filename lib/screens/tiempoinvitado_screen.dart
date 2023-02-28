import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

typedef void ScreenCallback(int id);

class TiempoInvitadoScreen extends StatefulWidget {
  // final ScreenCallback volver;
  // TiempoInvitadoScreen({required this.volver});

  @override
  State<TiempoInvitadoScreen> createState() => _TiempoInvitadoScreenState();
}

class _TiempoInvitadoScreenState extends State<TiempoInvitadoScreen> {

  String fechaDesde = '';
  String fechaHasta = '';
  String horaDesde = '';
  String horaHasta = '';

  ScreensVisitantesController controller = Get.find();

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
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text("Invitacion", textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                //Navigator.pushNamed(context, EntrarPage.routeName);
              }, // Handle your callback.
              splashColor: Color.fromARGB(255, 252, 190, 75).withOpacity(0.5),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                // fixedSize: Size(150, 70),
                foregroundColor: Color.fromARGB(255, 252, 190, 75),
                //disabledForegroundColor: Colors.red,
                side: BorderSide(color: Colors.orange, width: 3),
              ),
                onPressed: (() async {
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
                  DateTime fechaAhora = DateTime.now();
                  // print(fechaAhora);
                  fechaDesde = DateFormat('yyyy-MM-dd').format(fechaAhora);
                  horaDesde = DateFormat.Hms().format(fechaAhora);
                  horaHasta = horaDesde;
                  // print(fechaDesde);
                  // print(horaDesde);
                  DateTime fecha1dia = fechaAhora.add(Duration(days: 1));
                  // print(fecha1dia);
                  fechaHasta = DateFormat('yyyy-MM-dd').format(fecha1dia);
                  // print(fechaHasta);
                  // print(horaHasta);
                  String tiempoEstadiaInvitado= await jsonEncode({'fecha_entrada':fechaDesde, 'fecha_salida':fechaHasta, 'entrada':horaDesde, 'salida':horaHasta});
                  await Constants.prefs.setString('tiempoInvitado', tiempoEstadiaInvitado);
                  // setState(() {
                      
                  //     // print("state 3");
                  //   });
                  Navigator.of(context).pop();
                  // widget.volver(4);
                  controller.cambiarScreen(4);
                }
              ), 
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/9,
                  child: Center(
                    child: Text("Desde ahora por 24 Horas", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),),
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
              splashColor: Color.fromARGB(255, 116, 168, 245).withOpacity(0.5),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                // fixedSize: Size(150, 70),
                foregroundColor: Color.fromARGB(255, 116, 168, 245),
                //disabledForegroundColor: Colors.red,
                side: BorderSide(color: Colors.blue, width: 3),
              ),
                onPressed: (() {
                  // widget.volver(3);
                  controller.cambiarScreen(3);
                // setState(() {
                    
                //     // print("state 3");
                //   });
                }), 
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/4,
                  child: Center(
                    child: Text("Personalizada", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 45),),
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
            // MaterialButton(
            //   child: Container(
            //   ),
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //               title: Text(''),
            //               content: Container(
            //                 height: 350,
            //                 child: Column(
            //                   children: <Widget>[
            //                     getDateRangePicker(),
            //                     MaterialButton(
            //                       child: Text("OK"),
            //                       onPressed: () {
            //                         print(fechaDesde);
            //                         print(fechaHasta);
            //                         Navigator.pop(context);
            //                       },
            //                     )
            //                   ],
            //                 ),
            //               ));
            //         });
            //   },
            // ),
          ],
        ),
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Center(
      //     child: Column(
      //       children: [
      //         Container(
      //           child: Column(
      //             children: [
      //               SizedBox(
      //                 height: 20,
      //               ),
      //               Text('Seleccione el tiempo de estadia de su invitado', 
      //               textAlign: TextAlign.center, 
      //               style: TextStyle(
      //                 fontSize: 30,
      //                 fontWeight: FontWeight.bold
      //               ),
      //               ),
      //               SizedBox(
      //                 height: 60,
      //               ),
      //               Text('Actualmente no tiene invitados', 
      //               textAlign: TextAlign.center, 
      //               style: TextStyle(
      //                 fontSize: 30,
      //                 fontWeight: FontWeight.bold
      //               ),
      //               ),
      //             ],
      //           )
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton( 
          child: Icon(Icons.arrow_back_rounded, size: 40,),  
          onPressed: (() {
            controller.cambiarScreen(0);
            // widget.volver(0);
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    )
  );
}