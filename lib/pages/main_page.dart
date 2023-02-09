import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
// import 'package:seguricel_flutter/utils/drawer.dart';
// import 'package:seguricel_flutter/name_card_widget.dart';
// import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/pages/login_page.dart';
import 'package:seguricel_flutter/screens/aperturas_screen.dart';
import 'dart:convert';
import 'package:seguricel_flutter/screens/home_screen.dart';
import 'package:seguricel_flutter/screens/invitados_screen.dart';
import 'package:seguricel_flutter/utils/constants.dart';
// import 'package:seguricel_flutter/utils/loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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

  int _selectedIndex=1;
  static final List<Widget>_widgetOptions = <Widget>[
    HomeScreen(),
    AperturasScreen(),
    InvitadosScreen(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   //fetchData2();
  // }
  
  // fetchData2()async{
  //   //SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
  //   // String encodeContratos = await Constants.prefs.getString('contratos').toString();
  //   // String encodeAccesos = await Constants.prefs.getString('accesos').toString();

  //   // print(encodeDatosUsuario);
  //   // print(encodeContratos);
  //   // print(encodeAccesos);
  //   setState(() {
  //     //datosUsuario = jsonDecode(encodeDatosUsuario);
  //     // contratos = jsonDecode(encodeContratos);
  //     // accesos = jsonDecode(encodeAccesos);
  //   });
  //   // datosUsuario = await jsonDecode(encodeDatosUsuario);
  //   // contratos = await jsonDecode(encodeContratos);
  //   // accesos = await jsonDecode(encodeAccesos);
  
  //   // print(datosUsuario);
  //   // print(contratos);
  //   // print(accesos);

  //   // setState(() { });
  //   //print(this.url);
  //   // var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
  //   // var res = await client.post(url);
  //   // data = jsonDecode(res.body);
  //   // setState(() {
      
  //   // });
  // }
  
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
      // body: this.datosUsuario!={}
      //   ?Center(
        body: Center(
          child: _widgetOptions[_selectedIndex]
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
        items: 
          const [
            // BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
            // BottomNavigationBarItem(icon: Icon(Icons.door_sliding_rounded),label: "aperturas"),
            // BottomNavigationBarItem(icon: Icon(Icons.groups),label: "invitados"),
            BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.door_sliding_rounded),label: "Aperturas"),
            BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_people_community_add_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_people_community_add_filled),
              label: "Visitantes"
              ),
          ]
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
