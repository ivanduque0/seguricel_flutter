import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

typedef void ScreenCallback(int id);


class infoUsuarioScreen extends StatefulWidget {
  final ScreenCallback volver;
  infoUsuarioScreen({required this.volver});

  @override
  State<infoUsuarioScreen> createState() => _infoUsuarioScreenState();
}

class _infoUsuarioScreenState extends State<infoUsuarioScreen> {
  
  Map datosUsuario = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerDatos();
  }

  obtenerDatos()async{

    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    setState(() {
      datosUsuario = jsonDecode(encodeDatosUsuario);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: 
            (datosUsuario['nombre']!=null || datosUsuario['id_usuario']!=null || datosUsuario['contrato']!=null)
            ?Column(
              children: [
                ListTile(
              leading: Icon(Icons.person, size: 60,),
              title: Text("Nombre", style: TextStyle(fontSize: 20),),
              subtitle: Text(datosUsuario['nombre'], style: TextStyle(fontSize: 20),),
              //trailing: Icon(Icons.edit),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_ind_rounded, size: 60,),
              title: Text("ID", style: TextStyle(fontSize: 20),),
              subtitle: Text(datosUsuario['id_usuario'], style: TextStyle(fontSize: 20)),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
              //trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.house_rounded, size: 60,),
              title: Text("Contrato", style: TextStyle(fontSize: 20),),
              subtitle: Text(datosUsuario['contrato'], style: TextStyle(fontSize: 20),),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
              //trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.accessibility_new_rounded, size: 60,),
              title: Text("Rol", style: TextStyle(fontSize: 20),),
              subtitle: Text("Propietario", style: TextStyle(fontSize: 20),),
              onTap: () {
                // print(datosUsuario);
                // print("a");
              },
              //trailing: Icon(Icons.edit),
            ),
              ],
            ):LoadingWidget(),
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