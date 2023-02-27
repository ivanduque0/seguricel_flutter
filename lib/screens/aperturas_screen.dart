import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seguricel_flutter/pages/entrar_page.dart';
import 'package:seguricel_flutter/pages/salir_page.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
class AperturasScreen extends StatefulWidget {
  const AperturasScreen({super.key});
  static const String routeName = "/main";

  @override
  State<AperturasScreen> createState() => _AperturasScreenState();
}




class _AperturasScreenState extends State<AperturasScreen> {

  String uuid="";
  bool bluetooth=false;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // obtenerUUID();

    // // Get current state
    // FlutterBluetoothSerial.instance.state.then((state) {
    //   setState(() {
    //     _bluetoothState = state;
    //   });
    // });

    // // Listen for futher state changes
    // FlutterBluetoothSerial.instance
    //     .onStateChanged()
    //     .listen((BluetoothState state) {
    //   setState(() {
    //     _bluetoothState = state;
    //   });
    // });

  }
  
  // obtenerUUID( )async{
  //   bool bluetoothSP= await Constants.prefs.getBool('modoBluetooth') ?? false;
  //   String encodeUUID = await Constants.prefs.getString('beacon_uuid').toString();
  //   setState(() {
  //     uuid = encodeUUID;
  //     bluetooth= bluetoothSP;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: _hideShowBluetooth(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.pushNamed(context, EntrarPage.routeName);
                }, // Handle your callback.
                splashColor: Colors.brown.withOpacity(0.5),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 30, 255, 41),
                    primary: Colors.black,
                  ),
                  onPressed: (() {
                    Get.toNamed("/entrar");
                    // Navigator.pushNamed(context, EntrarPage.routeName);
                  //print("SALIDAS SCREEN");
                  }), 
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    child: Center(
                      child: Text("ENTRAR",
                              style: TextStyle(fontSize: 60),),
                    ),
                    // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20)
                      
                    // ),
                  ),
                ),
                // Ink(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height/3,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     image: DecorationImage(
                //       image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.pushNamed(context, SalirPage.routeName);
                }, // Handle your callback.
                splashColor: Colors.brown.withOpacity(0.5),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    primary: Colors.black,
                  ),
                  onPressed: (() {
                    Get.toNamed("/salir");
                    // Navigator.pushNamed(context, SalirPage.routeName);
                  //print("SALIDAS SCREEN");
                  }), 
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    child: Center(
                      child: Text("SALIR",
                              style: TextStyle(fontSize: 60),),
                    ),
                    // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20)
                      
                    // ),
                  ),
                )
                // Ink(
                //  width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height/3,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     image: DecorationImage(
                //       image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height/3,
                // child: TextButton(
                //   style: TextButton.styleFrom(
                //     backgroundColor: Colors.red,
                //     primary: Colors.black,
                //   ),
                //   onPressed: (() {
                //     Navigator.pushNamed(context, SalirPage.routeName);
                //   //print("SALIDAS SCREEN");
                //   }), 
                //   child: Container(
                //     child: Text("SALIR",
                //             style: TextStyle(fontSize: 60),),
                //     // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                //     // decoration: BoxDecoration(
                //     //   borderRadius: BorderRadius.circular(20)
                      
                //     // ),
                //   ),
                // ),
              // ),
              // Container(
              //   child: Center(child: Text("SALIR")),
              //   decoration: BoxDecoration(
              //     color: Colors.red,
              //     borderRadius: BorderRadius.circular(20)
              //   ),
              //   width: 300,
              //   height: 250,
              // )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _hideShowBluetooth() {
  //   if (!bluetooth) {
  //     return Container();
  //   } else {
  //     return FloatingActionButton.large(
  //       backgroundColor: Color.fromARGB(255, 2, 49, 255),
  //       onPressed: () async {
  //         bool bluetoothEnable = _bluetoothState.isEnabled;
  //         // bool isAdvertising = await Constants.beaconBroadcast.isAdvertising() ?? false;
  //         // if (!bluetoothEnable){
  //         //   await FlutterBluetoothSerial.instance.requestEnable();
  //         // }
  //         // else{
  //         //   await FlutterBluetoothSerial.instance.requestDisable();
  //         // }
  //         Map<Permission, PermissionStatus> statuses = await [
  //         Permission.location,
  //         Permission.bluetooth,
  //         Permission.bluetoothConnect,
  //         Permission.bluetoothAdvertise,
  //         // Permission.locationWhenInUse,
  //         // Permission.locationAlways
  //         ].request();
  //         //print(statuses);
  //         //print(bluetoothEnable);
  //         if (!bluetoothEnable){
  //           await FlutterBluetoothSerial.instance.requestEnable();
  //           // setState(() {
  //           //   isAdvertising;
  //           // });
            
  //           // print(isAdvertising);
  //           // print("activar bluetooth");
  //           Constants.beaconBroadcast
  //             .setUUID(uuid)
  //             .setMajorId(8462)
  //             .setMinorId(37542)
  //             .setTransmissionPower(10)
  //             .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
  //             .setManufacturerId(0x004c)
  //             .setAdvertiseMode(AdvertiseMode.lowLatency)
  //             .start();

  //           // print(isAdvertising);
  //           AwesomeDialog(
  //             titleTextStyle: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 30,
  //               color: Colors.green
  //             ),
  //             // descTextStyle: TextStyle(
  //             //   fontWeight: FontWeight.bold,
  //             //   fontSize: 20,
  //             // ),
  //             context: context,
  //             animType: AnimType.topSlide,
  //             headerAnimationLoop: false,
  //             dialogType: DialogType.info,
  //             showCloseIcon: true,
  //             title: "¡Transmitiendo por bluetooth!",
  //             //desc:"Solicitud enviada",
  //             btnOkColor: Colors.blue,
  //             btnOkOnPress: () {
  //               //debugPrint('OnClcik');
  //             },
  //             btnOkIcon: Icons.check_circle,
  //             // onDismissCallback: (type) {
  //             //   debugPrint('Dialog Dissmiss from callback $type');
  //             // },
  //           ).show();
  //         await Future.delayed(const Duration(seconds: 30), () async {
  //           bool isAdvertising = await Constants.beaconBroadcast.isAdvertising() ?? false;
  //           if (_bluetoothState.isEnabled || isAdvertising){
  //             await Constants.beaconBroadcast.stop();
  //             await FlutterBluetoothSerial.instance.requestDisable();
  //           }
            
  //         });

          

  //       } else {
  //         await Constants.beaconBroadcast.stop();

  //         FlutterBluetoothSerial.instance.requestDisable();

  //         AwesomeDialog(
  //             titleTextStyle: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 30,
  //               color: Colors.red
  //             ),
  //             // descTextStyle: TextStyle(
  //             //   fontWeight: FontWeight.bold,
  //             //   fontSize: 20,
  //             // ),
  //             context: context,
  //             animType: AnimType.topSlide,
  //             headerAnimationLoop: false,
  //             dialogType: DialogType.info,
  //             showCloseIcon: true,
  //             title: "¡Apagando transmision por bluetooth!",
  //             //desc:"Solicitud enviada",
  //             btnOkColor: Colors.blue,
  //             btnOkOnPress: () {
  //               //debugPrint('OnClcik');
  //             },
  //             btnOkIcon: Icons.check_circle,
  //             // onDismissCallback: (type) {
  //             //   debugPrint('Dialog Dissmiss from callback $type');
  //             // },
  //           ).show();
  //       }
  //       },
  //       child: new IconTheme(
  //           data: new IconThemeData(color: Colors.white), 
  //           child: new Icon(Icons.bluetooth_rounded, size: 80),
  //       )
  //     );
  //   }
  // }
}