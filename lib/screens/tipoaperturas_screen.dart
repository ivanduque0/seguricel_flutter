import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

typedef void ScreenCallback(int id);

class tipoAperturaScreen extends StatefulWidget {
  final ScreenCallback volver;
  tipoAperturaScreen({required this.volver});

  @override
  State<tipoAperturaScreen> createState() => _tipoAperturaScreenState();
}

class _tipoAperturaScreenState extends State<tipoAperturaScreen> {
  bool internet=false;
  bool bluetooth=false;
  bool wifi=false;
  bool gps=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarParametros();
  }


  cargarParametros(){
    setState(() {
      internet= Constants.prefs.getBool('modoInternet') ?? false;
      bluetooth= Constants.prefs.getBool('modoBluetooth') ?? false;
      wifi= Constants.prefs.getBool('modoWifi') ?? false;
    });
  }
  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      widget.volver(0);
      return false;
    },
    child: Scaffold(
      body: Center(child: !(internet==false && wifi==false && bluetooth==false)
      ?Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height:30
          ),
          Text("Mis tipos de apertura", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          SizedBox(
            height:40
          ),
          SwitchListTile(
            title: const Text('DATOS', style: TextStyle(fontSize: 30),),
            value: internet,
            onChanged: (bool value) {
              setState(() {
                internet = value;
              });
              Constants.prefs.setBool('modoInternet', value);
              Constants.prefs.setBool('modoWifi', !value);
              setState(() {
                wifi=!value;
              });
            },
            //secondary: const Icon(Icons.lightbulb_outline),
          ),
          SwitchListTile(
            title: const Text('WIFI', style: TextStyle(fontSize: 30),),
            value: wifi,
            onChanged: (bool value) {
              setState(() {
                wifi = value;
              });
              Constants.prefs.setBool('modoWifi', value);
              Constants.prefs.setBool('modoInternet', !value);
              setState(() {
                internet=!value;
              });
            },
            //secondary: const Icon(Icons.lightbulb_outline),
          ),
          SwitchListTile(
            title: const Text('BLUETOOTH', style: TextStyle(fontSize: 30),),
            value: bluetooth,
            onChanged: (bool value) {
              setState(() {
                bluetooth = value;
              });
              Constants.prefs.setBool('modoBluetooth', value);
            },
            //secondary: const Icon(Icons.lightbulb_outline),
          ),
          // SwitchListTile(
          //   title: const Text('GPS'),
          //   value: internet,
          //   onChanged: (bool value) {
          //     setState(() {
          //       gps = value;
          //     });
          //   },
          //   //secondary: const Icon(Icons.lightbulb_outline),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text("INTERNET"),
          //     FlutterSwitch(
          //         activeColor: Colors.orange,
          //         width: 125.0,
          //         height: 55.0,
          //         valueFontSize: 25.0,
          //         toggleSize: 45.0,
          //         value: internet,
          //         borderRadius: 30.0,
          //         padding: 8.0,
          //         showOnOff: true,
          //         onToggle: (value) {
          //           setState(() {
          //             internet = value;
          //           });
          //           Constants.prefs.setBool('modoInternet', value);
          //           Constants.prefs.setBool('modoWifi', !value);
          //           setState(() {
          //             wifi=!value;
          //           });
          //         },
          //       ),
          //   ],
          // ),
        ],
      )
      :LoadingWidget(),
      ),
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
    ),
  );
}