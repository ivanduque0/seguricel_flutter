import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:get/get.dart';

typedef void ScreenCallback(int id);

class SeleccionarInvitadoExistenteScreen extends StatefulWidget {
  // final ScreenCallback volver;
  // SeleccionarInvitadoExistenteScreen({required this.volver});

  @override
  State<SeleccionarInvitadoExistenteScreen> createState() => _SeleccionarInvitadoExistenteScreenState();
}

class _SeleccionarInvitadoExistenteScreenState extends State<SeleccionarInvitadoExistenteScreen> {

  Map tiempoInvitado={};
  Map datosPropietario={};
  List invitados=[];
  List invitadosAgregados=[];
  String imei="";
  ScreensVisitantesController controller = Get.find();

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    obtenerInvitados();
    
  }

  obtenerInvitados() async {
    String encodeTiempoInvitado = await Constants.prefs.getString('tiempoInvitado').toString();
    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    String encodeDatosInvitados = await Constants.prefs.getString('datosInvitados').toString();
    imei = await Constants.prefs.getString('imei').toString();
    setState (() {
      invitados = (jsonDecode(encodeDatosInvitados) as List<dynamic>).cast<Map>();
      tiempoInvitado = jsonDecode(encodeTiempoInvitado);
      datosPropietario = jsonDecode(encodeDatosUsuario);
      // print(invitados);
      // datosPropietario = jsonDecode(encodeDatosUsuario);
      // print(tiempoInvitado);
      // print(datosPropietario);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      controller.cambiarScreen(4);
      // widget.volver(4);
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
              height: 10,
            ),
            Text("¿A quienes desea invitar?", textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 20,
            ),
            (invitadosAgregados.length>0)?Padding(
              padding: const EdgeInsets.fromLTRB(0,0,10,0),
              child: Text("Acompañantes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.right,),
            ):SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width/1.2,
              height: MediaQuery.of(context).size.height/2.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromARGB(255, 240, 162, 73),
                    width: 3,
                  )
              ),
              child: ListView.builder(
                itemCount: invitados.length,
                shrinkWrap: true,
                itemBuilder:(context, index) => Container(
                  color: invitadosAgregados.contains(invitados[index])?Color.fromARGB(255, 180, 255, 150):Colors.white,
                  child: ListTile(
                    // leading: Icon(Icons.person),
                    title:Text("${invitados[index]['nombre']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    subtitle: Text("Codigo: ${invitados[index]['telegram_id']}"),
                    trailing: invitadosAgregados.contains(invitados[index])?Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              if (invitados[index]['acompanantes']>0){
                                setState(() {
                                invitados[index]['acompanantes']--;
                              });
                              } 
                            }, // Handle your callback.
                            splashColor: Colors.brown.withOpacity(0.5),
                            child: Ink(
                              width:40,
                              height: 40,
                              child: Icon(Icons.remove, size: 30, color: Colors.red,),
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
                          child: Text("${invitados[index]['acompanantes']}", 
                            style: TextStyle(
                              fontSize: 30
                            ),)
                        ),
                        Expanded(
                          flex: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              setState(() {
                                invitados[index]['acompanantes']++;
                              });
                            }, // Handle your callback.
                            splashColor: Colors.brown.withOpacity(0.5),
                            child: Ink(
                              width:40,
                              height: 40,
                              child: Icon(Icons.add, size: 30, color: Colors.green,),
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
                    ):Icon(Icons.person_add_alt_rounded, color: Colors.green),
                    onTap: (() {
                      //widget.volver(1);
                      if (invitados[index]['acompanantes']==null){
                        setState(() {
                          invitados[index]['acompanantes']=0;
                        });
                      }
                      if(invitadosAgregados.contains(invitados[index])){
                        setState(() {
                        invitadosAgregados.remove(invitados[index]);
                      });
                      } else {
                      setState(() {
                        invitadosAgregados.add(invitados[index]);
                      });
                      }
                      // print(invitadosAgregados);
                    }),
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     invitadosPorInvitar.contains(invitados[index])?IconButton(
                    //     icon: Icon(Icons.remove), 
                    //     color: Colors.red,
                    //     onPressed: () async {
                    //       setState(() {
                    //         invitadosPorInvitar.remove(invitados[index]);
                    //       });
                          
                    //     },
                    //     )
                    //     // SizedBox(width: 10,),
                    //     :IconButton(
                    //       icon: Icon(Icons.add), color: Colors.green,
                    //       onPressed: () async {
                    //         setState(() {
                    //           invitadosPorInvitar.add(invitados[index]);
                    //         });
                    //         print(invitadosPorInvitar);
                    //       }, 
                    //     ),
                    //   ],
                    // ),
                    // onTap: () async {

                    // },
                  ),
                ), 
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                onPressed:(invitadosAgregados.length==0)? null : () async {     
                   int usuariosAgregados=0;             
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
                      for (var invitado in invitadosAgregados) {
                        tiempoInvitado['usuario']=invitado['id'].toString();
                        tiempoInvitado['cedula']=invitado['cedula'].toString();
                        tiempoInvitado['contrato']=invitado['contrato'].toString();
                        tiempoInvitado['acompanantes'] = invitado['acompanantes'].toString();
                        //print(tiempoInvitado);
                        var res = await client.post(Uri.parse('https://webseguricel.up.railway.app/editarhorariosvisitantesapi/${tiempoInvitado['usuario'].toString()}/'), body: tiempoInvitado).timeout(Duration(seconds: 5));
                        var data = await jsonDecode(res.body);
                        //print(" horas: $data");
                        String mensaje='INVITACION RES. ${datosPropietario['contrato']}\n\nNombre: ${invitado['nombre']}\nCodigo: ${invitado['telegram_id']}\nFecha: ${tiempoInvitado['fecha_entrada']}\nAcompañantes: ${invitado['acompanantes']}\n\nSi desea abrir con su telefono por proximidad via Bluetooth, descargue la aplicacion.\n\nAndroid: ${Constants.linkAndroid}\n\niOs: ${Constants.linkIOS}';
                        // print(mensaje);
                        res = await client.get(Uri.parse('https://api.callmebot.com/whatsapp.php?phone=${Constants.numeroBot}&text=!sendto+${datosPropietario['numero_telefonico']}+${mensaje}&apikey=${Constants.apiKeyBot}')).timeout(Duration(seconds: 5));
                        var dataMensajes = res.body;
                        // print(dataMensajes);
                        usuariosAgregados++;
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
                        title: invitadosAgregados.length==1?"Invitacion enviada\n\nREVISE SU WHATSAPP":"Invitaciones enviadas\n\nREVISE SU WHATSAPP",
                        //desc:"Solicitud enviada",
                        btnOkColor: Colors.green,
                        btnOkOnPress: () {
                          
                          //debugPrint('OnClcik');
                        },
                        btnOkIcon: Icons.check_circle,
                        onDismissCallback: (type) {
                          controller.cambiarScreen(1);
                          //debugPrint('Dialog Dissmiss from callback $type');
                        },
                      ).show();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Invitaciones registradas!')),
                      //   );
                      // widget.volver(1);
                      
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
                        title: usuariosAgregados==0?"No hubo respuesta del servidor":"Algunas invitaciones no se registraron",
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
                child: Text(invitadosAgregados.length<=1?"Enviar invitacion":"Enviar invitaciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                ),
              ),
            ),
          ],
          ),
        ),
      ),

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