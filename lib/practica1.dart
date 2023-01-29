import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
  ));
}

class HomePage extends StatelessWidget {
  // const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seguricel"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          //color: Colors.red,
          width: 100,
          height: 100,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.yellow]
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
              ),
            ],
            //shape: BoxShape.circle
          ),
          child: Text(
            "I am a box",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              
            ),),
        ),
      ),
    );
  }
}
