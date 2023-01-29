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
      body: Center(
        child: Container(
          color: Colors.teal,
          height: 100,
          width: 100,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Ivan Jose Duque Luna", style: TextStyle( color: Colors.white),), 
              accountEmail: Text("27488274", style: TextStyle( color: Colors.white),),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://images.unsplash.com/photo-1566753323558-f4e0952af115?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=721&q=80"),
              )
            ),
            // DrawerHeader(
            //   child: Text("olawenasxd"),
            //   decoration: BoxDecoration(color: Colors.orange,),
            // ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Ivan Jose Duque Luna"),
              subtitle: Text("Propietario"),
              //trailing: Icon(Icons.edit),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.assignment_ind_rounded),
              title: Text("Cedula"),
              subtitle: Text("27488274"),
              //trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.house_rounded),
              title: Text("Contrato"),
              subtitle: Text("Villa de campo"),
              //trailing: Icon(Icons.edit),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.settings_rounded,
          size: 30,
          // color: Colors.white,
          ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
