import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/controllers/screens_unidad_controller.dart';
import 'package:seguricel_flutter/controllers/apertura_visitante_controller.dart';
import 'package:get/get.dart';
import 'package:seguricel_flutter/screens/codigo_unidad_screen.dart';
import 'package:seguricel_flutter/screens/infovigilante_screen.dart';
import 'package:seguricel_flutter/screens/codigo_invitado_screen.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import '../controllers/codigo_unidad_controller.dart';
import '../controllers/codigo_visitante_controller.dart';
import '../controllers/personas_unidad_controller.dart';
import '../controllers/personas_visitante_controller.dart';

class MainPage extends StatefulWidget {
  static const String routeName = "/main";
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // const MainPage({super.key});
  // var myText = "Change my name";
  // TextEditingController _nameController = TextEditingController();
  
  // var url= Uri(
  //   scheme: 'https',
  //   host: 'webseguricel.up.railway.app',
  //   path: '/dispositivosapimobile/754/');
  // var url = Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/orangepii96/');
  // var data;
  //Map datosUsuario={};
  // List contratos=[];
  List accesos=[];

  ScreensVisitantesController controller = Get.put(ScreensVisitantesController());
  ScreensUnidadController controllerUnidad = Get.put(ScreensUnidadController());
  AperturaVisitanteController aperturaVisitanteController = Get.put(AperturaVisitanteController());
  CodigoVisitanteController codigoVisitanteController = Get.put(CodigoVisitanteController());
  CodigoUnidadController codigoUnidadController = Get.put(CodigoUnidadController());
  PersonasUnidadController personasUnidadController = Get.put(PersonasUnidadController());
  PersonasVisitanteController personasVisitanteController = Get.put(PersonasVisitanteController());


  List<BottomNavigationBarItem> itemsVigilante=const [
    // BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
    // BottomNavigationBarItem(icon: Icon(Icons.door_sliding_rounded),label: "aperturas"),
    // BottomNavigationBarItem(icon: Icon(Icons.groups),label: "invitados"),
    BottomNavigationBarItem(
      icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
      activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
      label: "Home"),
    BottomNavigationBarItem(
      icon: Icon(Icons.door_sliding_rounded),
      label: "Aperturas"),
    BottomNavigationBarItem(
      icon: Icon(FluentSystemIcons.ic_fluent_people_regular),
      activeIcon: Icon(FluentSystemIcons.ic_fluent_people_filled),
      label: "Visitantes"
      ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }       



  int _selectedIndex=1;
  static final List<Widget>_widgetOptionsVigilante = <Widget>[
    infoVigilanteScreen(),
    //HomeScreen(),
    CodigoUnidadScreen(),
    //AperturasScreen(),
    InvitadosScreen(),
  ];

  void _onItemTapped(int index){
    if (index==2){
      codigoVisitanteController.cambiarCodigo("");
      aperturaVisitanteController.cambiarVisitante(false);
      controller.cambiarScreen(0);
    }
    if (index==1){
      
      if (controllerUnidad.unidadScreen!=0){
        codigoUnidadController.cambiarCodigo("");
      }
      personasUnidadController.cambiarpersonas("");
      controllerUnidad.cambiarScreen(0);
    }
    setState(() {
      _selectedIndex=index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Seguricel",
          style: TextStyle(
            color: Colors.white
          ),
          ),
        // actions: [
        //   IconButton(
        //     onPressed: (() async {
        //       //SharedPreferences prefs = await SharedPreferences.getInstance();
        //       // Constants.prefs.remove("datosUsuario");
        //       // Constants.prefs.remove("accesos");
        //       // Constants.prefs.remove("contratos");
        //       // Constants.prefs.remove("isLoggedIn");
        //       Constants.prefs.clear();
        //       Get.offNamed("/login");
        //       //Navigator.pop(context);
        //     }), 
        //     icon: Icon(Icons.exit_to_app_rounded)
        //   ),
        // ],
      ),
      // body: this.datosUsuario!={}
      //   ?Center(
        body: Center(
          child: _widgetOptionsVigilante[_selectedIndex]
        ),
        //:LoadingWidget(),
      //drawer: MyDrawer(datosUsuario: datosUsuario),//datosUsuario!={}?MyDrawer(datosUsuario: datosUsuario):MyDrawer(datosUsuario: {'nombre':"null", "contrato":"null","cedula":"null", "id_usuario":"null"}),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        //selectedItemColor: Colors.blue,
        unselectedItemColor: Color.fromARGB(255, 109, 101, 94),
        items: itemsVigilante
      ),
      
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //   },
      //   child: Icon(
      //     Icons.settings_rounded,
      //     size: 30,
      //     // color: Colors.white,
      //     ),
      // ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
