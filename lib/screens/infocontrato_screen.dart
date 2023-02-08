import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';

typedef void ScreenCallback(int id);

class infoContratoScreen extends StatefulWidget {
  final ScreenCallback volver;
  infoContratoScreen({required this.volver});

  @override
  State<infoContratoScreen> createState() => _infoContratoScreenState();
}

class _infoContratoScreenState extends State<infoContratoScreen> {
  List contratos=[];
  Map datosUsuario={};
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obetenerData();
  }

  obetenerData()async{
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodeDatosUsuario = await Constants.prefs.getString('datosUsuario').toString();
    String encodeContratos = await Constants.prefs.getString('contratos').toString();
    // String encodeAccesos = await Constants.prefs.getString('accesos').toString();

    // print(encodeDatosUsuario);
    // print(encodeContratos);
    // print(encodeAccesos);
    setState (() {
      datosUsuario = jsonDecode(encodeDatosUsuario);
      contratos = jsonDecode(encodeContratos);
      // accesos = jsonDecode(encodeAccesos);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: 
            (contratos.length!=0)
            ?Center(
              child: Text(contratos[0]),
            )
            :LoadingWidget(),
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