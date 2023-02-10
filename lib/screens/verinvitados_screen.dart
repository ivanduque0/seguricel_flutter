import 'package:flutter/material.dart';

typedef void ScreenCallback(int id);

class VerInvitadosScreen extends StatefulWidget {
  final ScreenCallback volver;
  VerInvitadosScreen({required this.volver});

  @override
  State<VerInvitadosScreen> createState() => _VerInvitadosScreenState();
}

class _VerInvitadosScreenState extends State<VerInvitadosScreen> {
  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      widget.volver(0);
      return false;
    },
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Mis invitados', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text('Actualmente no tiene invitados', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
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
    )
  );
}