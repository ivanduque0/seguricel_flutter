import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

typedef void ScreenCallback(int id);

class VerInvitadosScreen extends StatefulWidget {
  final ScreenCallback volver;
  VerInvitadosScreen({required this.volver});

  @override
  State<VerInvitadosScreen> createState() => _VerInvitadosScreenState();
}

class _VerInvitadosScreenState extends State<VerInvitadosScreen> {

  Map datosUsuario={};
  List invitados=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerInvitados();
  }

  obtenerInvitados() async {

    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    String encodeDatosInvitados = await Constants.prefs.getString('datosInvitados').toString();
    //print(idUsuario);

    // print(encodeDatosUsuario);
    // print(encodeContratos);
    // print(encodeAccesos);
    setState (() {
      datosUsuario= jsonDecode(encodeDatosUsuario);
      invitados= (jsonDecode(encodeDatosInvitados) as List<dynamic>).cast<Map>();
    });
    //print(invitados);
    try {

      var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
      var res = await client.get(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${datosUsuario['contrato_id']}/${datosUsuario['cedula']}/Visitante/')).timeout(Duration(seconds: 5));
      var actualizarInvitados = (jsonDecode(res.body) as List<dynamic>).cast<Map>();
      if (res.body!=encodeDatosInvitados){
        await Constants.prefs.setString('datosInvitados', res.body);
        setState(() {
          invitados=actualizarInvitados;
        });
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      widget.volver(0);
      return false;
    },
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Mis invitados', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    (datosUsuario=={})
                    ?LoadingWidget()
                    :(datosUsuario!={} && invitados.length==0)
                    ?Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Text('Actualmente no tiene invitados', 
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                    :Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.8,
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
                      itemBuilder:(_, index) => Container(
                        child: ListTile(
                          // leading: Icon(Icons.person),
                          title:Text("${invitados[index]['nombre']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          subtitle: Text("Codigo: ${invitados[index]['telegram_id']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                              icon: Icon(Icons.edit), 
                              color: Colors.blue,
                              onPressed: () async {
                                //print(invitados[index]);
                                String datosInvitado=jsonEncode({'internet':invitados[index]['telefonoInternet'], 'wifi':invitados[index]['telefonoWifi'], 'bluetooth':invitados[index]['telefonoBluetooth'],'nombre':invitados[index]['nombre'], 'codigo':invitados[index]['telegram_id'], 'cedula':invitados[index]['cedula'], 'id':invitados[index]['id'], 'contrato_id':invitados[index]['contrato'], 'cedula_propietario':invitados[index]['cedula_propietario']});
                               
                                await Constants.prefs.setString('datosInvitadoEditar', datosInvitado);
                                //print(datosInvitado);
                                widget.volver(6);
                              },
                              ),
                              SizedBox(width: 10,),
                              IconButton(
                                icon: Icon(Icons.delete), color: Colors.red,
                                onPressed: () async {
                                  AwesomeDialog(
                                    btnCancelText: "NO",
                                    btnOkText: "SI",
                                    titleTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black
                                    ),
                                    // descTextStyle: TextStyle(
                                    //   fontWeight: FontWeight.bold,
                                    //   fontSize: 20,
                                    //   color: Colors.black
                                    // ),
                                    context: context,
                                    animType: AnimType.bottomSlide,
                                    headerAnimationLoop: false,
                                    dialogType: DialogType.warning,
                                    showCloseIcon: true,
                                    title: "¿Seguro que desea eliminar al invitado ${invitados[index]['nombre']}?",
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      bool cerrarLoading=false;
                                      showDialog(
                                        // The user CANNOT close this dialog  by pressing outsite it
                                        barrierDismissible: false,
                                        context: _,
                                        builder: (_) {
                                          return WillPopScope(
                                            onWillPop: () async => false,
                                            child: LoadingWidget());
                                        }
                                      );
                                      try {
                                        var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                                        var res = await client.delete(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${invitados[index]['id']}/blank/blank/')).timeout(Duration(seconds: 5));
                                        var data = await jsonDecode(res.body);
                                        // print(data);
                                        if(res.statusCode==200){
                                          setState(() {
                                          invitados.removeAt(index);
                                        });
                                        var invitadosEncode = await jsonEncode(invitados);
                                        await Constants.prefs.setString('datosInvitados', invitadosEncode);
                                        cerrarLoading=true;
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
                                          title: "¡Invitado eliminado con exito!",
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
                                        }
                                      } catch (e) {
                                        if (cerrarLoading==false){
                                          Navigator.of(context).pop();
                                        }
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
                                    },
                                  ).show();
                                }, 
                              ),
                            ],
                          ),
                          // onTap: () async {

                          // },
                        ),
                      )
                        
                      , 
                    ),
                  ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: FloatingActionButton( 
      //     child: Icon(Icons.arrow_back_rounded, size: 40,),  
      //     onPressed: (() {
      //       widget.volver(0);
      //     }),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    )
  );
}