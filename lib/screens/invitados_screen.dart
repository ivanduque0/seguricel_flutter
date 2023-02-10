import 'package:flutter/material.dart';
import 'package:seguricel_flutter/screens/agregarinvitado_screen.dart';
import 'package:seguricel_flutter/screens/verinvitados_screen.dart';

class InvitadosScreen extends StatefulWidget {
  const InvitadosScreen({super.key});

  @override
  State<InvitadosScreen> createState() => _InvitadosScreenState();
}

class _InvitadosScreenState extends State<InvitadosScreen> {
  int screen=0;

  void updateScreen(int newScreen) {
    setState(() {
      screen = newScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: screen==0?Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text("Configuracion de visitantes", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  //Navigator.pushNamed(context, EntrarPage.routeName);
                }, // Handle your callback.
                splashColor: Color.fromARGB(255, 255, 175, 110).withOpacity(0.5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                  fixedSize: Size(220, 100),
                  foregroundColor: Colors.orange[300],
                  //disabledForegroundColor: Colors.red,
                  side: BorderSide(color: Colors.orange, width: 3),
                ),
                  onPressed: (() {
                    setState(() {
                      screen=1;
                      // print("state 3");
                    });
                  }), 
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    child: Center(
                      child: Text("Mis\ninvitados", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 40),),
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
              SizedBox(
                height: 20,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  //Navigator.pushNamed(context, EntrarPage.routeName);
                }, // Handle your callback.
                splashColor: Color.fromARGB(255, 175, 255, 110).withOpacity(0.5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                  fixedSize: Size(220, 100),
                  foregroundColor: Colors.green[300],
                  //disabledForegroundColor: Colors.red,
                  side: BorderSide(color: Colors.green, width: 3),
                ),
                  onPressed: (() {
                  setState(() {
                      screen=2;
                      // print("state 3");
                    });
                  }), 
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    child: Center(
                      child: Text("Agregar\ninvitados", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 40),),
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
            ],
          ):
          screen==1?VerInvitadosScreen(
            volver: updateScreen,
          ):AgregarInvitadoScreen(
            volver: updateScreen
          )
        ),
      ),
    );
  }
}