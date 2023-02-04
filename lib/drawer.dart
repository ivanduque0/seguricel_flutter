import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final datosUsuario;

  const MyDrawer({super.key, required this.datosUsuario});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(datosUsuario['nombre'], style: TextStyle( color: Colors.white),), 
              accountEmail: Text(datosUsuario['id_usuario'], style: TextStyle( color: Colors.white),),
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
              title: Text(datosUsuario['nombre']),
              subtitle: Text("Propietario"),
              //trailing: Icon(Icons.edit),
              onTap: () {
                print(datosUsuario);
                print("a");
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_ind_rounded),
              title: Text("Cedula"),
              subtitle: Text(datosUsuario['cedula']),
              //trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.house_rounded),
              title: Text("Contrato"),
              subtitle: Text(datosUsuario['contrato']),
              //trailing: Icon(Icons.edit),
            ),
          ],
        ),
      );
  }
}