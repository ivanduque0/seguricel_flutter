import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:seguricel_flutter/drawer.dart';
// import 'package:seguricel_flutter/name_card_widget.dart';
import 'package:http_auth/http_auth.dart';
import 'package:seguricel_flutter/screens/aperturas_screen.dart';
import 'dart:convert';

import 'package:seguricel_flutter/screens/home_screen.dart';
import 'package:seguricel_flutter/screens/invitados_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var url = Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/orangepii96/');
  var data;
  Map datosUsuario={};
  List contratos=[];
  Map accesos={};

  int _selectedIndex=0;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  

  fetchData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var encodeDatosUsuario = prefs.getString('datosUsuario');
    var encodeContratos = prefs.getString('contrtos');
    var encodeAccesos = prefs.getString('contrtos');

    datosUsuario = jsonDecode(encodeDatosUsuario.toString());
    contratos = jsonDecode(encodeContratos.toString());
    accesos = jsonDecode(encodeAccesos.toString());

    print(datosUsuario);
    print(contratos);
    print(accesos);


    //print(this.url);
    // var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
    // var res = await client.post(url);
    // data = jsonDecode(res.body);
    // setState(() {
      
    // });
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
        actions: [
          IconButton(
            onPressed: (() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("datosUsuario");
              prefs.remove("accesos");
              prefs.remove("contratos");
              prefs.remove("isLoggedIn");
              Navigator.pop(context);

            }), 
            icon: Icon(Icons.exit_to_app_rounded)
          ),
        ],
      ),
      body: datosUsuario!=null || contratos!=null
        ?Center(
          child: _widgetOptions[_selectedIndex]
        )
        // ?ListView.builder(
        //   itemBuilder: (context, index){
        //     return ListTile(
        //       title: Text(data[index]["descripcion"]),
        //       subtitle: Text("URL: ${data[index]["dispositivo"]}"),
        //       leading: Icon(Icons.device_hub),
        //     );
        //   },
        //   itemCount: data.length,
        // )
        :Center(
          child: CircleAvatar(
            backgroundColor: Colors.orange,
            radius: 75,
            child: CircleAvatar(
              radius: 71,
              backgroundImage: AssetImage("assets/images/gif_loading.gif"),
            )
          ),
        ),
      drawer: MyDrawer(),
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
              label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.door_sliding_rounded),label: "aperturas"),
            BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_people_community_add_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_people_community_add_filled),
              label: "invitados"
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
