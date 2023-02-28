import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:seguricel_flutter/controllers/rol_controller.dart';

typedef void ScreenCallback(int id);

class infoContratoScreen extends StatefulWidget {
  final ScreenCallback volver;
  infoContratoScreen({required this.volver});

  @override
  State<infoContratoScreen> createState() => _infoContratoScreenState();
}

class _infoContratoScreenState extends State<infoContratoScreen> {
  List contratos=[];
  Map datosUsuario={};
  String seleccionContrato ="";
  List <String>ContratosActualizar=[];

  RolController rolController= Get.find();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obetenerData();
  }

  obetenerData()async{
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    String encodeContratos = await Constants.prefs.getString('contratos').toString();
    String idUsuario= await Constants.prefs.getString('id_usuario').toString();
    //print(idUsuario);

    // print(encodeDatosUsuario);
    // print(encodeContratos);
    // print(encodeAccesos);
    setState (() {
      datosUsuario = jsonDecode(encodeDatosUsuario);
      contratos = (jsonDecode(encodeContratos) as List<dynamic>).cast<Map>();
      seleccionContrato = datosUsuario['contrato'];
      // accesos = jsonDecode(encodeAccesos);
    });

    try{
    var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
    var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/contratosmobiledeviceapi/${idUsuario}/')).timeout(Duration(seconds: 5));
    var ContratosActualizar = jsonDecode(res.body);
    //print(ContratosActualizar);
    // for (var item in data) {
    //   ContratosActualizar.add(item['contrato']);
    // }
    if (contratos!=ContratosActualizar){
      setState(() {
        contratos=ContratosActualizar;
      });
      String contratosEncode=jsonEncode(contratos);
      await Constants.prefs.setString('contratos', contratosEncode);
    }
    }catch(e){
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
        title: "Sin conexion a internet",
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
                    // Navigator.of(context).pop();
    }
    
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      widget.volver(0);
      return false;
    },
    child: Scaffold(
            body: 
            (contratos.length>1 && seleccionContrato!="")
            ?Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height:20
                  ),
                  Text("Informacion de contratos", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  SizedBox(
                    height:MediaQuery.of(context).size.height/15
                  ),
                  Text("Seleccione el contrato\nal que desea cambiar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  // CustomScrollView(
                  //   slivers: [
                  //     SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                        
                  //     },))
                  //   ],
                  // )

                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 240, 162, 73),
                          width: 3,
                        )
                      ),
                    child: ListView.builder(
                      itemCount: contratos.length,
                      shrinkWrap: true,
                      itemBuilder:(context, index) => Container(
                        child: ListTile(
                          title: (contratos[index]['nombre']==seleccionContrato)
                          ?Text(contratos[index]['nombre'], textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),)
                          :Text(contratos[index]['nombre'], textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                          onTap: () async {
                  
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
                            String servidor="";
                            List accesosEntradas=[];
                            List accesosSalidas=[];
                            // print(contratos[index]['rol']);
                            rolController.cambiarrol(contratos[index]['rol']);
                            // This is called when the user selects an item.
                            datosUsuario['contrato']=contratos[index]['nombre'];
                            datosUsuario['contrato_id']=contratos[index]['id'];
                            datosUsuario['unidad']=contratos[index]['unidad'];
                            datosUsuario['rol']=contratos[index]['rol'];
                            try {
                              var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                              var res = await client.post(Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/${contratos[index]['nombre']}/')).timeout(Duration(seconds: 5));//.timeout(Duration(seconds: 15));;
                              var data = jsonDecode(res.body);
                              var descripcionIteracion="";
                              for (var item in data) {
                                if (servidor=="" && item['descripcion']=="SERVIDOR LOCAL"){
                                  servidor="${item['dispositivo']}:43157/";
                                } else {
                                  descripcionIteracion=item['descripcion'];
                                  
                                  if ((descripcionIteracion.toLowerCase().contains('peatonal') || descripcionIteracion.toLowerCase().contains('vehicular')) && !descripcionIteracion.toLowerCase().contains('salida') && !(descripcionIteracion.toLowerCase().contains('rfid') || descripcionIteracion.toLowerCase().contains('huella'))){
                                    accesosEntradas.add({'acceso':item['acceso'].toString(), 'descripcion':item['descripcion'].substring(0, item['descripcion'].indexOf('('))});
                                  }
                                  if ((descripcionIteracion.toLowerCase().contains('peatonal') || descripcionIteracion.toLowerCase().contains('vehicular')) && !descripcionIteracion.toLowerCase().contains('entrada') && !(descripcionIteracion.toLowerCase().contains('rfid') || descripcionIteracion.toLowerCase().contains('huella'))){
                                    accesosSalidas.add({'acceso':item['acceso'].toString(), 'descripcion':item['descripcion'].substring(0, item['descripcion'].indexOf('('))});
                                  }
                                }
                              }
                              String datosUsuarioEnconde=jsonEncode(datosUsuario);
                              // accesos=jsonEncode([AccesosPeatonales,AccesosVehiculares]);
                              String entradas=jsonEncode(accesosEntradas);
                              String salidas=jsonEncode(accesosSalidas);
                              await Constants.prefs.setString('datosUsuario', datosUsuarioEnconde);
                              await Constants.prefs.setString('entradas', entradas);
                              await Constants.prefs.setString('salidas', salidas);
                              await Constants.prefs.setString('servidor', servidor);
                              await Constants.prefs.setString('contrato', contratos[index]['nombre']);
                              setState(() {
                                seleccionContrato = contratos[index]['nombre'];
                        
                              });
                              Navigator.of(context).pop();
                              AwesomeDialog(
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
                                title: "Contrato cambiado con exito",
                                //desc:"Solicitud enviada",
                                btnOkColor: Colors.green,
                                btnOkOnPress: () {
                                  //debugPrint('OnClcik');
                                },
                                btnOkIcon: Icons.check_circle,
                                // onDismissCallback: (type) {
                                //   debugPrint('Dialog Dissmiss from callback $type');
                                // },
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
                                title: "Sin conexion a internet",
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
                        ),
                      )
                        
                      , 
                    ),
                  ),


                  // Container(
                  //   width: MediaQuery.of(context).size.width/1.5,
                  //   height: 70,
                  //   child: DropdownButton<String>(
                  //     value: seleccionContrato,
                  //     isExpanded: true,
                  //     icon: const Icon(Icons.arrow_downward_outlined),
                  //     elevation: 16,
                  //     menuMaxHeight: 220,
                  //     style: const TextStyle(color: Color.fromARGB(255, 221, 113, 25), fontSize: 20),
                  //     underline: Container(
                  //       height: 2,
                  //       color: Color.fromARGB(255, 221, 113, 25),
                  //     ),
                  //     onChanged: (String? value) async {
                  //       showDialog(
                  //         // The user CANNOT close this dialog  by pressing outsite it
                  //         barrierDismissible: false,
                  //         context: context,
                  //         builder: (_) {
                  //           return WillPopScope(
                  //             onWillPop: () async => false,
                  //             child: LoadingWidget());
                  //         }
                  //       );
                  //       String servidor="";
                  //       List accesosEntradas=[];
                  //       List accesosSalidas=[];
                  //       // This is called when the user selects an item.
                  //       datosUsuario['contrato']=value;
                  //       try {
                  //         var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                  //         var res = await client.post(Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/${value}/')).timeout(Duration(seconds: 5));//.timeout(Duration(seconds: 15));;
                  //         var data = jsonDecode(res.body);
                  //         var descripcionIteracion="";
                  //         for (var item in data) {
                  //           if (servidor=="" && item['descripcion']=="SERVIDOR LOCAL"){
                  //             servidor="${item['dispositivo']}:43157/";
                  //           } else {
                  //             descripcionIteracion=item['descripcion'];
                              
                  //             if ((descripcionIteracion.toLowerCase().contains('peatonal') || descripcionIteracion.toLowerCase().contains('vehicular')) && !descripcionIteracion.toLowerCase().contains('salida') && !(descripcionIteracion.toLowerCase().contains('rfid') || descripcionIteracion.toLowerCase().contains('huella'))){
                  //               accesosEntradas.add({'acceso':item['acceso'].toString(), 'descripcion':item['descripcion'].substring(0, item['descripcion'].indexOf('('))});
                  //             }
                  //             if ((descripcionIteracion.toLowerCase().contains('peatonal') || descripcionIteracion.toLowerCase().contains('vehicular')) && !descripcionIteracion.toLowerCase().contains('entrada') && !(descripcionIteracion.toLowerCase().contains('rfid') || descripcionIteracion.toLowerCase().contains('huella'))){
                  //               accesosSalidas.add({'acceso':item['acceso'].toString(), 'descripcion':item['descripcion'].substring(0, item['descripcion'].indexOf('('))});
                  //             }
                  //           }
                  //         }
                  //         String datosUsuarioEnconde=jsonEncode(datosUsuario);
                  //         // accesos=jsonEncode([AccesosPeatonales,AccesosVehiculares]);
                  //         String entradas=jsonEncode(accesosEntradas);
                  //         String salidas=jsonEncode(accesosSalidas);
                  //         await Constants.prefs.setString('datosUsuario', datosUsuarioEnconde);
                  //         await Constants.prefs.setString('entradas', entradas);
                  //         await Constants.prefs.setString('salidas', salidas);
                  //         await Constants.prefs.setString('servidor', servidor);
                  //         await Constants.prefs.setString('contrato', value!);
                  //         setState(() {
                  //           seleccionContrato = value;
                    
                  //         });
                  //         Navigator.of(context).pop();
                  //         AwesomeDialog(
                  //           titleTextStyle: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 30,
                  //             color: Colors.green
                  //           ),
                  //           // descTextStyle: TextStyle(
                  //           //   fontWeight: FontWeight.bold,
                  //           //   fontSize: 20,
                  //           // ),
                  //           context: context,
                  //           animType: AnimType.topSlide,
                  //           headerAnimationLoop: false,
                  //           dialogType: DialogType.success,
                  //           showCloseIcon: true,
                  //           title: "Contrato cambiado con exito",
                  //           //desc:"Solicitud enviada",
                  //           btnOkColor: Colors.green,
                  //           btnOkOnPress: () {
                  //             //debugPrint('OnClcik');
                  //           },
                  //           btnOkIcon: Icons.check_circle,
                  //           // onDismissCallback: (type) {
                  //           //   debugPrint('Dialog Dissmiss from callback $type');
                  //           // },
                  //         ).show();
                  //       } catch (e) {
                  //         Navigator.of(context).pop();
                  //         AwesomeDialog(
                  //     titleTextStyle: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 30,
                  //       color: Colors.red
                  //     ),
                  //     // descTextStyle: TextStyle(
                  //     //   fontWeight: FontWeight.bold,
                  //     //   fontSize: 20,
                  //     // ),
                  //     context: context,
                  //     animType: AnimType.bottomSlide,
                  //     headerAnimationLoop: false,
                  //     dialogType: DialogType.error,
                  //     showCloseIcon: true,
                  //     title: "Sin conexion a internet",
                  //     //desc:"Solicitud enviada",
                  //     btnOkOnPress: () {
                  //       //debugPrint('OnClcik');
                  //     },
                  //     btnOkColor: Colors.red,
                  //     btnOkIcon: Icons.check_circle,
                  //     // onDismissCallback: (type) {
                  //     //   debugPrint('Dialog Dissmiss from callback $type');
                  //     // },
                  //   ).show();
                  //       }
                  //     },
                  //     items: contratos.map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                ],
              ),
            )
            :(contratos.length==1 && seleccionContrato!="")
            ?Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height:40
                  ),
                  Text("Informacion de contrato", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  SizedBox(
                    height:MediaQuery.of(context).size.height/15
                  ),
                  Text("Actualmente usted\npertenece solo al contrato:\n${seleccionContrato.toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
            :LoadingWidget(),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton( 
                child: Icon(Icons.arrow_back_rounded, size: 40,),  
                onPressed: (() {
                  widget.volver(0);
                }),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
          )
  );
}