import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:seguricel_flutter/controllers/visitantes_controller.dart';

typedef void ScreenCallback(int id);

class AgregarInvitadosPage extends StatefulWidget {
  // final ScreenCallback volver;
  // AgregarInvitadosPage({required this.volver});

  @override
  State<AgregarInvitadosPage> createState() => _AgregarInvitadosPageState();
}

class _AgregarInvitadosPageState extends State<AgregarInvitadosPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _cedulaController = TextEditingController();
  String nombre="";
  String cedula="";
  Map datosPropietario={};
  String imei="";
  String encodeDatosInvitados ="";

  VisitantesController visitantesController = Get.find();

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    obtenerPropietario();
    
  }

  obtenerPropietario() async {
    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    imei = await Constants.prefs.getString('imei').toString();
    encodeDatosInvitados = await Constants.prefs.getString('datosInvitados').toString();
    //String encodeDatosInvitados = await Constants.prefs.getString('datosInvitados').toString();
  
    setState (() {
      // invitados = (jsonDecode(encodeDatosInvitados) as List<dynamic>).cast<Map>();
      datosPropietario = jsonDecode(encodeDatosUsuario);
      //visitantesController.cambiarVisitantes(invitados);
      // print(invitados);
      // datosPropietario = jsonDecode(encodeDatosUsuario);
      // print(tiempoInvitado);
      // print(datosPropietario);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      // widget.volver(4);
      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Agregar invitado",
          style: TextStyle(
            color: Colors.white
          ),
          ),
        // actions: [
        //   IconButton(
        //     onPressed: (() async {
        //       //SharedPreferences prefs = await SharedPreferences.getInstance();
        //       Constants.prefs.remove("datosUsuario");
        //       Constants.prefs.remove("accesos");
        //       Constants.prefs.remove("contratos");
        //       Constants.prefs.remove("isLoggedIn");
        //       Navigator.pushReplacementNamed(context, LoginPage.routeName);
        //       //Navigator.pop(context);

        //     }), 
        //     icon: Icon(Icons.exit_to_app_rounded)
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
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
                  height: 40,
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
                                  var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                                  var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/sesionappapi/${datosPropietario['id_usuario']}/')).timeout(Duration(seconds: 5));
                                  var sesiondata = await jsonDecode(res.body);
                                  if (imei!=sesiondata['imei']){
                                    Constants.prefs.remove("datosUsuario");
                                    Constants.prefs.remove("accesos");
                                    Constants.prefs.remove("contratos");
                                    Constants.prefs.remove("isLoggedIn");
                                    Constants.prefs.remove('entradas');
                                    Constants.prefs.remove('salidas');
                                    Constants.prefs.remove('servidor');
                                    Constants.prefs.remove('id_usuario');
                                    Constants.prefs.remove('contrato');
                                    Constants.prefs.remove('beacon_uuid');
                                    Constants.prefs.remove('modoInternet');
                                    Constants.prefs.remove('modoWifi');
                                    Constants.prefs.remove('modoBluetooth');
                                    Constants.prefs.remove('imei');
                                    Navigator.of(context).pop();
                                    return Get.offNamed("/login");
                                  }
                                  Map jsonUsuario={"cedula":cedula, "nombre":nombre, "contrato":datosPropietario['contrato_id'].toString(), "rol":"Visitante","unidad":datosPropietario['unidad'].toString(),"cedula_propietario":datosPropietario['cedula'].toString()};
                                  String contratoId = datosPropietario['contrato_id'].toString();
                                  String cedulaId = datosPropietario['cedula'].toString();
                                  res = await client.post(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/$contratoId/$cedulaId/Visitante/'), body: jsonUsuario).timeout(Duration(seconds: 5));
                                  var dataUsuario = await jsonDecode(res.body);
                                  // print(dataUsuario);
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
                                  } 
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
                                      title: "Invitado agregado con exito",
                                      //desc:"Solicitud enviada",
                                      btnOkColor: Colors.green,
                                      btnOkOnPress: () {
                                        
                                        //debugPrint('OnClcik');
                                      },
                                      btnOkIcon: Icons.check_circle,
                                      onDismissCallback: (type) async {
                                        Get.back();
                                        try {
                                        //print(datosUsuario['id_usuario']);
                                        var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                                        res = await client.get(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${datosPropietario['contrato_id']}/${datosPropietario['cedula']}/Visitante/')).timeout(Duration(seconds: 5));
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
                              }
                            },
                            child: Text("Agregar", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
      )

      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Row(
      //     children: [
      //       FloatingActionButton( 
      //         child: Icon(Icons.arrow_back_rounded, size: 40,),  
      //         onPressed: (() {
      //           widget.volver(2);
      //         }),
      //       ),
      //       SizedBox(
      //         width:MediaQuery.of(context).size.width/3,
      //       ),
      //       // SizedBox(
      //       //   height: 50,
      //       //   width: 120,
      //       //   child: ElevatedButton(
      //       //     onPressed:(_nombreController.text=="" || _cedulaController.text=="")? null : (){widget.volver(4);},
      //       //     child: Text("Agregar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      //       //     style: ElevatedButton.styleFrom(
      //       //       backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
      //       //     ),
      //       //   ),
      //       // ),
      //       // OutlinedButton(
      //       //   style: OutlinedButton.styleFrom(
      //       //     fixedSize: Size(190, 50),
      //       //     foregroundColor: (fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")
      //       //                       ?Colors.grey
      //       //                       :Color.fromARGB(255, 125, 255, 74),
      //       //     //disabledForegroundColor: Colors.red,
      //       //     side: BorderSide(color: (fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")
      //       //                           ?Colors.grey
      //       //                           :Color.fromARGB(255, 125, 255, 74), width: 3),
      //       //   ),
      //       //   onPressed:(fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")? null : (){widget.volver(0);},
      //       //   child: Text("Continuar", style: TextStyle(fontSize: 18))
      //       // )
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    )
  );

}