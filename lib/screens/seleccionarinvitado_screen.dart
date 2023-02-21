import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seguricel_flutter/utils/constants.dart';

typedef void ScreenCallback(int id);

class SeleccionarInvitadoScreen extends StatefulWidget {
  final ScreenCallback volver;
  SeleccionarInvitadoScreen({required this.volver});

  @override
  State<SeleccionarInvitadoScreen> createState() => _SeleccionarInvitadoScreenState();
}

class _SeleccionarInvitadoScreenState extends State<SeleccionarInvitadoScreen> {

  List invitados=[];

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    obtenerInvitados();
  }

  obtenerInvitados() async {

    String encodeDatosInvitados = await Constants.prefs.getString('datosInvitados').toString();
    setState (() {
      invitados= jsonDecode(encodeDatosInvitados);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      widget.volver(2);
      return false;
    },
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
              height: 30,
            ),
            Text("Invitado", textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 40,
            ),
            invitados.length>0?InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                //Navigator.pushNamed(context, EntrarPage.routeName);
              }, // Handle your callback.
              splashColor: Color.fromARGB(255, 252, 190, 75).withOpacity(0.5),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                fixedSize: Size(150, 70),
                foregroundColor: Color.fromARGB(255, 252, 190, 75),
                //disabledForegroundColor: Colors.red,
                side: BorderSide(color: Colors.orange, width: 3),
              ),
                onPressed: (() async {
                  widget.volver(7);
                }), 
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3,
                  child: Center(
                    child: Text("Invitado existente", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),),
                  ),
                ),
              ),
            ):SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                //Navigator.pushNamed(context, EntrarPage.routeName);
              }, // Handle your callback.
              splashColor: Color.fromARGB(255, 9, 175, 37).withOpacity(0.5),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                fixedSize: Size(150, 70),
                foregroundColor: Color.fromARGB(255, 9, 175, 37),
                //disabledForegroundColor: Colors.red,
                side: BorderSide(color: Colors.green, width: 3),
              ),
                onPressed: (() {
                  widget.volver(5);
                // setState(() {
                    
                //     // print("state 3");
                //   });
                }), 
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3,
                  child: Center(
                    child: Text("Nuevo invitado", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),),
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FloatingActionButton( 
              child: Icon(Icons.arrow_back_rounded, size: 40,),  
              onPressed: (() {
                widget.volver(2);
              }),
            ),
            SizedBox(
              width:MediaQuery.of(context).size.width/3,
            ),
            // SizedBox(
            //   height: 50,
            //   width: 120,
            //   child: ElevatedButton(
            //     onPressed:(_nombreController.text=="" || _cedulaController.text=="")? null : (){widget.volver(4);},
            //     child: Text("Agregar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
            //     ),
            //   ),
            // ),
            // OutlinedButton(
            //   style: OutlinedButton.styleFrom(
            //     fixedSize: Size(190, 50),
            //     foregroundColor: (fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")
            //                       ?Colors.grey
            //                       :Color.fromARGB(255, 125, 255, 74),
            //     //disabledForegroundColor: Colors.red,
            //     side: BorderSide(color: (fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")
            //                           ?Colors.grey
            //                           :Color.fromARGB(255, 125, 255, 74), width: 3),
            //   ),
            //   onPressed:(fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")? null : (){widget.volver(0);},
            //   child: Text("Continuar", style: TextStyle(fontSize: 18))
            // )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    )
  );

}