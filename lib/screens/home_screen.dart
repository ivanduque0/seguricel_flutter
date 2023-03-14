import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:seguricel_flutter/controllers/contrato_controller.dart';
import 'package:seguricel_flutter/controllers/rol_controller.dart';
import 'package:seguricel_flutter/screens/infocontrato_screen.dart';
import 'package:seguricel_flutter/screens/infousuario_screen.dart';
import 'package:seguricel_flutter/screens/tipoaperturas_screen.dart';
import 'package:seguricel_flutter/controllers/screens_home_controller.dart';
import 'package:seguricel_flutter/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool modoInternet=false;
  int screen=0;
  //@override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   cargarParametros();
  // }

  ScreensHomeController homeController = Get.find();

  void updateScreen(int newScreen) {
    setState(() {
      screen = newScreen;
    });
  }

  // cargarParametros(){
  //   setState(() {
  //     modoInternet= Constants.prefs.getBool('modoInternet') ?? false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RolController>(builder: (RolController){
    return GetBuilder<ScreensHomeController>(builder: (ScreenController){
    return Container(
      width: MediaQuery.of(context).size.width/1.1,
      child: ScreenController.infoUsuarioScreen==0?Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 7,top:7),
            child: GetBuilder<ContratoController>(builder: (ContratoController){
              return Container(
                // width: MediaQuery.of(context).size.width/1.1,
                // height: MediaQuery.of(context).size.height/4.5,
                height: 140,
                child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          ScreenController.cambiarScreen(2);
                          // print("state 2");
                        });
                        //Navigator.pushNamed(context, EntrarPage.routeName);
                      }, // Handle your callback.
                      splashColor: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                      child: Ink(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text("Mis Residencias", style: TextStyle(fontSize: 25,)),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top:15),
                                child: Text("${ContratoController.contrato}", textAlign:TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                              )
                            ),
                          ],
                        ),
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height/3,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 168, 191, 241),
                          border: Border.all(
                            width: 2
                          ),
                          borderRadius: BorderRadius.circular(20),
                          // image: DecorationImage(
                          //   image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                    ),
                );
              }
            ),
          ),
          RolController.rol=='Propietario' || RolController.rol=='Secundario'
          ?Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Container(
              // width: MediaQuery.of(context).size.width/1.2,
              // height: MediaQuery.of(context).size.height/4.5,
              height: 70,
              child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        ScreenController.cambiarScreen(3);
                        // print("state 3");
                      });
                      //Navigator.pushNamed(context, EntrarPage.routeName);
                    }, // Handle your callback.
                    splashColor: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                    child: Ink(
                      // color: Colors.grey,
                      child: Center(child: Text("Mis tipos de apertura", textAlign:TextAlign.center, style: TextStyle(fontSize: 25, ),)),
                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height/3,
                      decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 168, 191, 241),
                        border: Border.all(
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(20),
                        // image: DecorationImage(
                        //   image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
            ),
          )
          :SizedBox(
            height: 7,
          ),
          Container(
            // width: MediaQuery.of(context).size.width/1.2,
            // height: MediaQuery.of(context).size.height/4.5,
            height: 70,
            child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      ScreenController.cambiarScreen(1);
                      // print("state 1");
                    });
                    
                    //Navigator.pushNamed(context, EntrarPage.routeName);
                  }, // Handle your callback.
                  splashColor: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                  child: Ink(
                    child: Center(child: Text("Informacion de usuario", textAlign:TextAlign.center, style: TextStyle(fontSize: 25,),)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                      // color: Color.fromARGB(255, 168, 191, 241),
                      border: Border.all(
                          width: 2
                        ),
                      borderRadius: BorderRadius.circular(20),
                      // image: DecorationImage(
                      //   image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
          ),
          
          // Text("Aperturas por internet", 
          // style: TextStyle(
          //   fontSize: 30
          // ),),
          // SizedBox(
          //   height: 10,
          // ),
          // FlutterSwitch(
          //   activeColor: Colors.orange,
          //   width: 125.0,
          //   height: 55.0,
          //   valueFontSize: 25.0,
          //   toggleSize: 45.0,
          //   value: modoInternet,
          //   borderRadius: 30.0,
          //   padding: 8.0,
          //   showOnOff: true,
          //   onToggle: (value) {
          //     setState(() {
          //       modoInternet = value;
          //     });
          //     Constants.prefs.setBool('modoInternet', value);
          //   },
          // ),
        ],
      ):
      ScreenController.infoUsuarioScreen==1?infoUsuarioScreen(
      ):
      ScreenController.infoUsuarioScreen==2?infoContratoScreen(
      ):
      tipoAperturaScreen(
      )
      
      
    //   Switch(
    //   thumbIcon: thumbIcon,
    //   value: modoInternet,
    //   activeColor: Colors.red,
    //   onChanged: (bool value) {
    //     // This is called when the user toggles the switch.
    //     setState(() {
    //       modoInternet = value;
    //     });
    //     Constants.prefs.setBool('modoInternet', value);
    //   },
    // )
    );
    }
    );
    });
  }
}