import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:seguricel_flutter/controllers/visitantes_controller.dart';

typedef void ScreenCallback(int id);

class EliminarInvitadosPage extends StatefulWidget {
  // final ScreenCallback volver;
  // EliminarInvitadosPage({required this.volver});

  @override
  State<EliminarInvitadosPage> createState() => _EliminarInvitadosPageState();
}

class _EliminarInvitadosPageState extends State<EliminarInvitadosPage> {

  // Map tiempoInvitado={};
  Map datosPropietario={};
  // List invitados=[];
  List invitadosAgregados=[];

  // VisitantesController visitantesController = Get.find();

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    obtenerInvitados();
    
  }

  obtenerInvitados() async {
    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Eliminar invitados",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
            IconButton(
              iconSize: 40,
              onPressed: (() async {
                Get.back();
              }),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )
            )
          ],
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
        child: GetBuilder<VisitantesController>(builder: (VisitantesController){ 
          return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Seleccione los invitados que desea eliminar de su lista", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: 5,
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
                itemCount: VisitantesController.visitantes.length,
                shrinkWrap: true,
                itemBuilder:(context, index) => Container(
                  color: invitadosAgregados.contains(VisitantesController.visitantes[index])?Color.fromARGB(255, 248, 134, 134):Color.fromARGB(0, 0, 0, 0),
                  child: ListTile(
                    // leading: Icon(Icons.person),
                    title:Text("${VisitantesController.visitantes[index]['nombre']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    subtitle: Text("Codigo: ${VisitantesController.visitantes[index]['telegram_id']}"),
                    trailing: invitadosAgregados.contains(VisitantesController.visitantes[index])?Row(
                      mainAxisSize: MainAxisSize.min,
                    ):Icon(Icons.delete_rounded, color: Color.fromARGB(255, 255, 0, 0)),
                    onTap: (() {
                      //widget.volver(1);
                      if (VisitantesController.visitantes[index]['acompanantes']==null){
                        setState(() {
                          VisitantesController.visitantes[index]['acompanantes']=0;
                        });
                      }
                      if(invitadosAgregados.contains(VisitantesController.visitantes[index])){
                        setState(() {
                        invitadosAgregados.remove(VisitantesController.visitantes[index]);
                      });
                      } else {
                      setState(() {
                        invitadosAgregados.add(VisitantesController.visitantes[index]);
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

                   int usuariosEliminados=0;

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
                        title: "¿Seguro que desea eliminar a los invitados seleccionados?",
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
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
                          bool cerrarLoading=false;
                          try {
                            for (var invitado in invitadosAgregados) {
                              int index = VisitantesController.visitantes.indexWhere(((inv) => inv['id'] == invitado['id']));
                              var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
                              var res = await client.delete(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${invitado['id']}/blank/blank/')).timeout(Duration(seconds: 5));
                              // var data = await jsonDecode(res.body);
                              //print(res.statusCode);
                              if(res.statusCode==200){
                                //   setState(() {
                                //   VisitantesController.visitantes.removeAt(index);
                                // });
                                VisitantesController.visitantes.removeAt(index);
                                VisitantesController.cambiarVisitantes(VisitantesController.visitantes);
                                var invitadosEncode = await jsonEncode(VisitantesController.visitantes);
                                await Constants.prefs.setString('datosInvitados', invitadosEncode);
                                usuariosEliminados++;
                              }
                            }
                            // widget.volver(1);
                            // Get.back();
                            cerrarLoading=true;
                            Navigator.of(context).pop();
                            setState(() {
                              invitadosAgregados=[];
                            });
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
                              title: "¡Invitados eliminados con exito!",
                              //desc:"Solicitud enviada",
                              btnOkColor: Colors.green,
                              btnOkOnPress: () {
                            //     if (VisitantesController.visitantes.length==0){
                            //   Get.back();
                            // }
                                //debugPrint('OnClcik');
                              },
                              btnOkIcon: Icons.check_circle,
                              onDismissCallback: (type) {
                                if (VisitantesController.visitantes.length==0){
                                  Get.back();
                                }
                                //debugPrint('Dialog Dissmiss from callback $type');
                              },
                            ).show();
                            
                          } catch (e) {
                            //print(e);
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
                              title: usuariosEliminados==0?"No hubo respuesta del servidor":"Algunos invitados no se eliminaron",
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

                      // AwesomeDialog(
                      //   titleTextStyle: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 30,
                      //     color: Colors.red
                      //   ),
                      //   // descTextStyle: TextStyle(
                      //   //   fontWeight: FontWeight.bold,
                      //   //   fontSize: 20,
                      //   // ),
                      //   context: context,
                      //   animType: AnimType.bottomSlide,
                      //   headerAnimationLoop: false,
                      //   dialogType: DialogType.error,
                      //   showCloseIcon: true,
                      //   title: usuariosEliminados==0?"No hubo respuesta del servidor":"Algunos invitados no se eliminaron",
                      //   //desc:"Solicitud enviada",
                      //   btnOkOnPress: () {
                      //     //debugPrint('OnClcik');
                      //   },
                      //   btnOkColor: Colors.red,
                      //   btnOkIcon: Icons.check_circle,
                      //   // onDismissCallback: (type) {
                      //   //   debugPrint('Dialog Dissmiss from callback $type');
                      //   // },
                      // ).show();
                },
                child: Text("Eliminar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (invitadosAgregados.length==0)?Colors.grey:Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color
                ),
              ),
            ),
          ],
          ),
        );
      }
      )
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