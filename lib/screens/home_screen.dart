import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:seguricel_flutter/controllers/contrato_controller.dart';
import 'package:seguricel_flutter/controllers/rol_controller.dart';
import 'package:seguricel_flutter/screens/infocontrato_screen.dart';
import 'package:seguricel_flutter/screens/infousuario_screen.dart';
import 'package:seguricel_flutter/screens/tipoaperturas_screen.dart';
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
    return Container(
      child: screen==0?Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/1.2,
            height: MediaQuery.of(context).size.height/4.5,
            child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      screen=1;
                      // print("state 1");
                    });
                    
                    //Navigator.pushNamed(context, EntrarPage.routeName);
                  }, // Handle your callback.
                  splashColor: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                  child: Ink(
                    child: Center(child: Text("Informacion\nde vigilante", textAlign:TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 168, 191, 241),
                      borderRadius: BorderRadius.circular(20),
                      // image: DecorationImage(
                      //   image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
          ),
          GetBuilder<ContratoController>(builder: (ContratoController){
          return Container(
            width: MediaQuery.of(context).size.width/1.2,
            height: MediaQuery.of(context).size.height/4.5,
            child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      screen=2;
                      // print("state 2");
                    });
                    //Navigator.pushNamed(context, EntrarPage.routeName);
                  }, // Handle your callback.
                  splashColor: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                  child: Ink(
                    child: Center(child: Text("Residencia\n${ContratoController.contrato}", textAlign:TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 168, 191, 241),
                      borderRadius: BorderRadius.circular(20),
                      // image: DecorationImage(
                      //   image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
          );}),
        ],
      ):
      screen==1?infoUsuarioScreen(
        volver: updateScreen,
      ):infoContratoScreen(
        volver: updateScreen,
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
    });
  }
}