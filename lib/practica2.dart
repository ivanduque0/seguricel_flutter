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
        title: Text(
          "Seguricel",
          style: TextStyle(
            color: Colors.white
          ),
          ),
      ),
      body: Container(
        color: Colors.teal,
        height: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red,
              width: 100,
              height: 100,
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.yellow,
              width: 100,
              height: 100,
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.green,
              width: 100,
              height: 100,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
