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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: !(internet==false && wifi==false && bluetooth==false)
      ?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("INTERNET"),
              FlutterSwitch(
                  activeColor: Colors.orange,
                  width: 125.0,
                  height: 55.0,
                  valueFontSize: 25.0,
                  toggleSize: 45.0,
                  value: internet,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (value) {
                    setState(() {
                      internet = value;
                    });
                    Constants.prefs.setBool('modoInternet', value);
                    Constants.prefs.setBool('modoWifi', !value);
                    setState(() {
                      wifi=!value;
                    });
                  },
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("WIFI"),
              FlutterSwitch(
                  activeColor: Colors.orange,
                  width: 125.0,
                  height: 55.0,
                  valueFontSize: 25.0,
                  toggleSize: 45.0,
                  value: wifi,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (value) {
                    setState(() {
                      wifi = value;
                    });
                    Constants.prefs.setBool('modoWifi', value);
                    Constants.prefs.setBool('modoInternet', !value);
                    setState(() {
                      internet=!value;
                    });
                  },
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("BLUETOOTH"),
              FlutterSwitch(
                  activeColor: Colors.orange,
                  width: 125.0,
                  height: 55.0,
                  valueFontSize: 25.0,
                  toggleSize: 45.0,
                  value: bluetooth,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (value) {
                    setState(() {
                      bluetooth = value;
                    });
                    Constants.prefs.setBool('modoBluetooth', value);
                  },
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("GPS"),
              FlutterSwitch(
                disabled: true,
                  activeColor: Colors.orange,
                  width: 125.0,
                  height: 55.0,
                  valueFontSize: 25.0,
                  toggleSize: 45.0,
                  value: false,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (value) {
                    setState(() {
                      internet = value;
                    });
                    //Constants.prefs.setBool('modoInternet', value);
                  },
                ),
            ],
          ),
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
    );
  }
}