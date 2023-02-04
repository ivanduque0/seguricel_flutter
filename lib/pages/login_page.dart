import 'package:flutter/material.dart';
import 'package:seguricel_flutter/pages/main_page.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_auth/http_auth.dart';
import 'dart:convert';

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
  var isLoggedIn;

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

  fetchData() async{
    var data;
    var res;
    List contratos=[];
    String contratosEncode="";
    String contrato="";
    String cedula="";
    String nombre="";
    String beacon_uuid="";
    String servidor="";
    String accesos="";
    Map AccesosPeatonales={};
    Map AccesosVehiculares={};
    String datosUsuario="";
    var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
    res = await client.get(Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/${_codeController.text}/'));//.timeout(Duration(seconds: 15));;
    data = jsonDecode(res.body);
    for (var item in data) {
      contratos.add(item['contrato']);
      if (cedula=="" && beacon_uuid=="" && nombre==""){
        cedula=item['cedula'];
        beacon_uuid=item['beacon_uuid'];
        nombre=item['nombre'];
      }
    }
    if (contratos.length>0){
      contrato= contratos[0];
      res = await client.post(Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/${contrato}/'));//.timeout(Duration(seconds: 15));;
      data = jsonDecode(res.body);
      var descripcionIteracion="";
      for (var item in data) {
        if (servidor=="" && item['descripcion']=="SERVIDOR LOCAL"){
          servidor="${item['dispositivo']}:43157/";
        } else {
          descripcionIteracion=item['descripcion'];
          if (descripcionIteracion.toLowerCase().contains('peatonal')){
            AccesosPeatonales[item['acceso'].toString()]=item['descripcion'].substring(0, item['descripcion'].indexOf('('));
          }
          if (descripcionIteracion.toLowerCase().contains('vehicular')){
            // print(item['descripcion']);
            // print(acceso.runtimeType);
            AccesosVehiculares[item['acceso'].toString()]=item['descripcion'].substring(0, item['descripcion'].indexOf('('));
          }
        }
      }
      // print(data);
      // print(servidor);
      // print(AccesosPeatonales);
      // print(AccesosVehiculares);
      datosUsuario=jsonEncode({'contrato':contrato, 'id_usuario':_codeController.text, 'cedula':cedula, 'nombre':nombre, 'beacon_uuid':beacon_uuid});
      accesos=jsonEncode([AccesosPeatonales,AccesosVehiculares]);
      contratosEncode=jsonEncode(contratos);

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      
      await Constants.prefs.setString('datosUsuario', datosUsuario);
      await Constants.prefs.setString('accesos', accesos);
      await Constants.prefs.setString('contratos', contratosEncode);
      await Constants.prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacementNamed(context, MainPage.routeName);
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
                          Text(_codeController.text),
                          TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Ingrese su codigo",
                              labelText: "Codigo"
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
                              fetchData();
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