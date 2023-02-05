import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:seguricel_flutter/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool modoInternet=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarParametros();
  }

  cargarParametros(){
    setState(() {
      modoInternet= Constants.prefs.getBool('modoInternet') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Aperturas por internet", 
          style: TextStyle(
            fontSize: 30
          ),),
          SizedBox(
            height: 10,
          ),
          FlutterSwitch(
            activeColor: Colors.orange,
            width: 125.0,
            height: 55.0,
            valueFontSize: 25.0,
            toggleSize: 45.0,
            value: modoInternet,
            borderRadius: 30.0,
            padding: 8.0,
            showOnOff: true,
            onToggle: (value) {
              setState(() {
                modoInternet = value;
              });
              Constants.prefs.setBool('modoInternet', value);
            },
          ),
        ],
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
}