import 'package:flutter/material.dart';

class AperturasScreen extends StatelessWidget {
  const AperturasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  primary: Colors.black,
                ),
                onPressed: (() {
                print("ENTRADAS SCREEN");
                }), 
                child: Container(
                  child: Text("ENTRAR",
                              style: TextStyle(fontSize: 24),),
                  // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(30)
                  // ),
                )
              ),
            ),
            SizedBox(
              width: 250,
              height: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  primary: Colors.black,
                ),
                onPressed: (() {
                print("SALIDAS SCREEN");
                }), 
                child: Container(
                  child: Text("SALIR",
                          style: TextStyle(fontSize: 24),),
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
    );
  }
}