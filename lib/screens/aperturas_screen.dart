import 'package:flutter/material.dart';
import 'package:seguricel_flutter/pages/entrar_page.dart';
import 'package:seguricel_flutter/pages/salir_page.dart';

class AperturasScreen extends StatelessWidget {
  const AperturasScreen({super.key});
  static const String routeName = "/main";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Color.fromARGB(255, 2, 49, 255),
        onPressed: () {
          print("activar bluetooth");
        },
        child: new IconTheme(
            data: new IconThemeData(color: Colors.white), 
            child: new Icon(Icons.bluetooth_rounded, size: 80),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    primary: Colors.black,
                  ),
                  onPressed: (() {
                  Navigator.pushNamed(context, EntrarPage.routeName);
                  //print("ENTRADAS SCREEN");
                  }), 
                  child: Container(
                    child: Text("ENTRAR",
                                style: TextStyle(fontSize: 60),),
                    // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(30)
                    // ),
                  )
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    primary: Colors.black,
                  ),
                  onPressed: (() {
                    Navigator.pushNamed(context, SalirPage.routeName);
                  //print("SALIDAS SCREEN");
                  }), 
                  child: Container(
                    child: Text("SALIR",
                            style: TextStyle(fontSize: 60),),
                    // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20)
                      
                    // ),
                  ),
                ),
              ),
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
}