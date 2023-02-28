import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seguricel_flutter/pages/main_page.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_auth/http_auth.dart';
import 'dart:convert';
import 'package:device_information/device_information.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //const LoginPage({super.key});
  final formKey = GlobalKey<FormState>();

  TextEditingController _codeController = TextEditingController();

  //final _passwordController = TextEditingController();
  bool isLoggedIn=false;

  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    // getBoolValuesSF();
    super.initState();
    // fetchData();
    
  }

  invertirUUID(String uuid){
    String uuidInvertido="";
    int cont=36;
    for( var i = 1 ; i <= 16; i++ ) { 
      // print(encodeUUID.substring(cont-2, cont));
      uuidInvertido=uuidInvertido+uuid.substring(cont-2, cont);
      cont=cont-2;
      // if (cont==8) {print(uuidInvertido);}
      if (i==4){
        uuidInvertido+='-';
      }  
      if (i==6){
        cont=cont-1;
        uuidInvertido+='-';
      }
      if (i==8){
         cont=cont-1;
        uuidInvertido+='-';
      }
      if (i==10){
        cont=cont-1;
        uuidInvertido+='-';
      } 
      if (i==12){
        cont=cont-1;
      }    
    }
    return uuidInvertido;
  }

  fetchData(BuildContext context, [bool mounted = true]) async{
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: LoadingWidget());
        // Dialog(
        //   // The background color
        //   backgroundColor: Colors.white,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 20),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: const [
        //         // The loading indicator
        //         LoadingWidget(),
        //         SizedBox(
        //           height: 15,
        //         ),
        //         // Some text
        //         Text('Espere por favor...', style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.orange,
        //           fontSize: 30
        //         ),)
        //       ],
        //     ),
        //   ),
        // );
      }
    );

    if (_codeController.text!='')
    {
      var data;
      var res;
      List contratos=[];
      String contratosEncode="";
      String contrato="";
      int unidad=0;
      String cedula="";
      String nombre="";
      String rol="";
      String numeroTelefonico="";
      String entrada_beacon_uuid="";
      String salida_beacon_uuid="";
      String servidor="";
      String entradas="";
      String salidas="";
      List accesosEntradas=[];
      List accesosSalidas=[];
      // Map AccesosPeatonales={};
      // Map AccesosVehiculares={};
      String datosUsuario="";

      try {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.phone,
          ].request();
        String imeiNo = await DeviceInformation.deviceIMEINumber;
        var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
        res = await client.get(Uri.parse('https://webseguricel.up.railway.app/sesionappapi/${_codeController.text}/')).timeout(Duration(seconds: 5));
        var sesiondata = jsonDecode(res.body);
        // print(sesiondata['imei']);
        if (sesiondata['imei']==0 || sesiondata['imei']==imeiNo){
          res = await client.get(Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/${_codeController.text}/')).timeout(Duration(seconds: 5));
          data = jsonDecode(res.body);
          // print(data);
          res = await client.get(Uri.parse('https://webseguricel.up.railway.app/contratosmobiledeviceapi/${_codeController.text}/')).timeout(Duration(seconds: 5));
          contratos = jsonDecode(res.body);
          // print(contratos);
          for (var item in data) {
            //print(item);
            // contratos.add(item['contrato']);
            if (cedula=="" && entrada_beacon_uuid=="" && salida_beacon_uuid=="" && nombre==""){
              cedula=item['cedula'];
              entrada_beacon_uuid=item['entrada_beacon_uuid'];
              salida_beacon_uuid=item['salida_beacon_uuid'];
              nombre=item['nombre'];
              rol=item['rol'];
              if (item['numero_telefonico']!=null){
                numeroTelefonico=item['numero_telefonico'].substring(1);
              }
              
              //print(numeroTelefonico);
            }
          }
          if (contratos.length>0){
            if (sesiondata['imei']==0){
              Map sesionjson= {'imei':imeiNo, 'codigo':_codeController.text};
              res = await client.post(Uri.parse('https://webseguricel.up.railway.app/sesionappapi/${_codeController.text}/'), body: sesionjson).timeout(Duration(seconds: 5));//.timeout(Duration(seconds: 15));;
              data = jsonDecode(res.body);
              // print(data);
            }
            //print(contratos[0]);
            contrato= contratos[0]['nombre'];
            res = await client.post(Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/${contrato}/')).timeout(Duration(seconds: 5));//.timeout(Duration(seconds: 15));;
            data = jsonDecode(res.body);
            var descripcionIteracion="";
            for (var item in data) {
              if (servidor=="" && item['descripcion']=="SERVIDOR LOCAL"){
                servidor="${item['dispositivo']}:43157/";
              } else {
                descripcionIteracion=item['descripcion'];
                
                // if (descripcionIteracion.toLowerCase().contains('peatonal')){
                if ((descripcionIteracion.toLowerCase().contains('peatonal') || descripcionIteracion.toLowerCase().contains('vehicular')) && !descripcionIteracion.toLowerCase().contains('salida') && !(descripcionIteracion.toLowerCase().contains('rfid') || descripcionIteracion.toLowerCase().contains('huella'))){
                  // print(descripcionIteracion);
                  accesosEntradas.add({'acceso':item['acceso'].toString(), 'descripcion':item['descripcion'].substring(0, item['descripcion'].indexOf('('))});
                }
                if ((descripcionIteracion.toLowerCase().contains('peatonal') || descripcionIteracion.toLowerCase().contains('vehicular')) && !descripcionIteracion.toLowerCase().contains('entrada') && !(descripcionIteracion.toLowerCase().contains('rfid') || descripcionIteracion.toLowerCase().contains('huella'))){
                  // print(descripcionIteracion);
                  accesosSalidas.add({'acceso':item['acceso'].toString(), 'descripcion':item['descripcion'].substring(0, item['descripcion'].indexOf('('))});
                }
                //   AccesosPeatonales[item['acceso'].toString()]=item['descripcion'].substring(0, item['descripcion'].indexOf('('));
                // }
                // if (descripcionIteracion.toLowerCase().contains('vehicular')){
                //   // print(item['descripcion']);
                //   // print(acceso.runtimeType);
                //   AccesosVehiculares[item['acceso'].toString()]=item['descripcion'].substring(0, item['descripcion'].indexOf('('));
                // }
              }
            }
            res = await client.get(Uri.parse('https://webseguricel.up.railway.app/agregarinvitadosmobileapi/${contratos[0]['id']}/${cedula}/Visitante/')).timeout(Duration(seconds: 5));
            var datosInvitados = res.body;
            //print(datosInvitados);
            // print(data);
            // print(servidor);
            // print(accesosEntradas);
            // print(accesosSalidas);
            // print(AccesosPeatonales);
            // print(AccesosVehiculares);
            datosUsuario=jsonEncode({'contrato':contrato, 'contrato_id':contratos[0]['id'], 'unidad':contratos[0]['unidad'], 'id_usuario':_codeController.text, 'cedula':cedula, 'nombre':nombre, 'rol': rol, 'entrada_beacon_uuid':entrada_beacon_uuid, 'salida_beacon_uuid':salida_beacon_uuid, 'numero_telefonico':numeroTelefonico});
            // accesos=jsonEncode([AccesosPeatonales,AccesosVehiculares]);
            entradas=jsonEncode(accesosEntradas);
            salidas=jsonEncode(accesosSalidas);
            contratosEncode=jsonEncode(contratos);

            //SharedPreferences prefs = await SharedPreferences.getInstance();
            
            await Constants.prefs.setString('datosUsuario', datosUsuario);
            await Constants.prefs.setString('datosInvitados', datosInvitados);
            await Constants.prefs.setString('entradas', entradas);
            await Constants.prefs.setString('salidas', salidas);
            await Constants.prefs.setString('contratos', contratosEncode);
            await Constants.prefs.setString('servidor', servidor);
            await Constants.prefs.setString('id_usuario', _codeController.text);
            await Constants.prefs.setString('contrato', contrato);
            await Constants.prefs.setString('entrada_beacon_uuid', invertirUUID(entrada_beacon_uuid));
            await Constants.prefs.setString('salida_beacon_uuid', invertirUUID(salida_beacon_uuid));
            await Constants.prefs.setBool('isLoggedIn', true);
            await Constants.prefs.setBool('modoInternet', true);
            await Constants.prefs.setBool('modoWifi', false);
            await Constants.prefs.setBool('modoBluetooth', true);
            await Constants.prefs.setString('imei', imeiNo);
            isLoggedIn=true;
            Navigator.pushReplacementNamed(context, MainPage.routeName);
          }
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
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
            title: "La cuenta se encuentra asociada a otro dispositivo",
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
        
      } catch (e) {
        Navigator.of(context).pop();
      }
    }
    if (!mounted) return;

    if (isLoggedIn){
      Get.offNamed("/main");
      // Navigator.pushReplacementNamed(context, MainPage.routeName);
    }
    
    // setState(() {
    // });
  }

// getBoolValuesSF() async {
//   Constants.prefs = await SharedPreferences.getInstance();
//   //Return bool
//   setState(() {
//     var isLoggedIn = Constants.prefs.getBool('isLoggedIn');
//     print(isLoggedIn);
//     if (isLoggedIn==true){
//       Navigator.pushReplacementNamed(context, MainPage.routeName);
//     }
//   });
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login page"),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/seguricelbackground.jpg", 
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Text(_codeController.text),
                          TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Ingrese su ID",
                              labelText: "ID"
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // TextFormField(
                          //   controller: _passwordController,
                          //   keyboardType: TextInputType.text,
                          //   obscureText: true,
                          //   decoration: InputDecoration(
                          //     hintText: "Ingrese contraseña",
                          //     labelText: "Contraseña"
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              fetchData(context);
                              // Constants.prefs?.setBool("loggedIn", true);
                              // Navigator.push(
                              //   context, 
                              //   MaterialPageRoute(
                              //     builder: ((context) => MainPage())));
                              //Navigator.pushReplacementNamed(context, MainPage.routeName);
                            }, 
                            child: Text("Ingresar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}