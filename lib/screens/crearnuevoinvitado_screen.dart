import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_auth/http_auth.dart';
import 'package:intl/intl.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

typedef void ScreenCallback(int id);

class CrearNuevoInvitadoScreen extends StatefulWidget {
  final ScreenCallback volver;
  CrearNuevoInvitadoScreen({required this.volver});

  @override
  State<CrearNuevoInvitadoScreen> createState() => _CrearNuevoInvitadoScreenState();
}

class _CrearNuevoInvitadoScreenState extends State<CrearNuevoInvitadoScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _cedulaController = TextEditingController();
  String nombre="";
  String cedula="";
  int acompanantes=0;
  Map datosPropietario={};
  Map tiempoInvitado={};

  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    obtenerTiempoEstadia();
    
  }

  obtenerTiempoEstadia() async {
    String encodeTiempoInvitado = await Constants.prefs.getString('tiempoInvitado').toString();
    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    //print(idUsuario);

    // print(encodeDatosUsuario);
    // print(encodeContratos);
    // print(encodeAccesos);
    setState (() {
      tiempoInvitado = jsonDecode(encodeTiempoInvitado);
      datosPropietario = jsonDecode(encodeDatosUsuario);
      // print(tiempoInvitado);
      // print(datosPropietario);
      // accesos = jsonDecode(encodeAccesos);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      widget.volver(4);
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
              Text("Datos del invitado", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: ((value) {
                          // print(value);
                          setState(() {
                            nombre = value;
                          });
                        }),
                        controller: _nombreController,
                        decoration: InputDecoration(
                          // contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 1.0),
                          border: OutlineInputBorder(),
                          //hintText: "Nombre de su invitado",
                          labelText: "Nombre del invitado"
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                                },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(nombre),
                      // Text(cedula),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: ((value) {
                          // print(value);
                          setState(() {
                            cedula = value;
                          });
                        }),
                        controller: _cedulaController,
                        decoration: InputDecoration(
                          // contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 1.0),
                          border: OutlineInputBorder(),
                          //hintText: "C.I. de su invitado",
                          labelText: "Cedula del invitado"
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter some text';
                        //   }
                        //   return null;
                        //         },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(nombre),
                      // Text(cedula),
                      Text("Cantidad de acompañantes", style: TextStyle(fontSize: 15),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                if (acompanantes>0){
                                  setState(() {
                                  acompanantes--;
                                });
                                } 
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                width:50,
                                height: 50,
                                child: Icon(Icons.remove, size: 40, color: Colors.red,),
                                // width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height/3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Text("${acompanantes}", 
                              style: TextStyle(
                                fontSize: 35
                              ),)
                          ),
                          Expanded(
                            flex: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  acompanantes++;
                                });
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                width:50,
                                height: 50,
                                child: Icon(Icons.add, size: 40, color: Colors.green,),
                                // width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height/3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              // child: Icon(Icons.arrow_back_rounded, size: 30,)
                              
                            ),
                          ),
                          
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: 120,
                        child: ElevatedButton(
                          onPressed:(nombre=="" || cedula=="")? null : () async {
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
                                Map jsonUsuario={"cedula":cedula, "nombre":nombre, "contrato":datosPropietario['contrato_id'].toString(), "rol":"Visitante","unidad":datosPropietario['unidad'].toString(),"cedula_propietario":datosPropietario['cedula'].toString()};
                                String contratoId = datosPropietario['contrato_id'].toString();
                                String cedulaId = datosPropietario['cedula'].toString();
                                var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                                var res = await client.post(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/$contratoId/$cedulaId/Visitante/'), body: jsonUsuario).timeout(Duration(seconds: 5));
                                var dataUsuario = await jsonDecode(res.body);
                                //print(dataUsuario);
                                if (dataUsuario['id']==null){
                                  Navigator.of(context).pop();
                                  AwesomeDialog(
                                    autoHide: Duration(seconds: 4),
                                  titleTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
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
                                  title: "No se pudo crear el nuevo visitante puesto que ya existe",
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
                                  return;
                                } else {
                                  tiempoInvitado['usuario']=dataUsuario['id'].toString();
                                  tiempoInvitado['cedula']=cedula;
                                  tiempoInvitado['contrato']=datosPropietario['contrato_id'].toString();
                                  tiempoInvitado['acompanantes'] = acompanantes.toString();
                                  res = await client.post(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${tiempoInvitado['usuario'].toString()}/'), body: tiempoInvitado).timeout(Duration(seconds: 5));
                                  var data = await jsonDecode(res.body);
                                  //print(" horas: $data");
                                  //print("acompanantes: $data");
                                  Navigator.of(context).pop();
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Invitado registrado!')),
                                  );
                                  widget.volver(1);
                                }
                                //widget.volver(1);
                              
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
                          child: Text("Agregar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                          ),
                        ),
                      ),
                    ],
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
                widget.volver(4);
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