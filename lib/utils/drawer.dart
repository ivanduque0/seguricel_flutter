import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final Map datosUsuario;

  const MyDrawer({super.key, required this.datosUsuario});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // getBoolValuesSF();
  //   super.initState();
  //   comprobar();
    
  // }

  // comprobar(){
  //   print(widget.datosUsuario);
  //   print("hecho");
  // }
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            // UserAccountsDrawerHeader(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: NetworkImage("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
            //       fit: BoxFit.cover
            //     )
            //   ),
            //   accountName: widget.datosUsuario!={}
            //   ?Text(widget.datosUsuario['nombre'], style: TextStyle( color: Colors.white),)
            //   :Text("cargando", style: TextStyle( color: Colors.white),), 
            //   accountEmail: widget.datosUsuario!={}
            //   ?Text(widget.datosUsuario['id_usuario'], style: TextStyle( color: Colors.white),)
            //   :Text("cargando", style: TextStyle( color: Colors.white),), 
            //   // currentAccountPicture: CircleAvatar(
            //   //   backgroundImage: NetworkImage("https://images.unsplash.com/photo-1566753323558-f4e0952af115?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=721&q=80"),
            //   // )
            // ),
            DrawerHeader(
              child: Text(""),
              // decoration: BoxDecoration(color: Colors.orange,),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                  fit: BoxFit.cover
                )
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: widget.datosUsuario!={}
              ?Text(widget.datosUsuario['nombre'])
              :Text("cargando"),
              subtitle: Text("Propietario"),
              //trailing: Icon(Icons.edit),
              onTap: () {
                // print(widget.datosUsuario);
                // print("a");
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_ind_rounded),
              title: Text("Cedula"),
              subtitle: widget.datosUsuario!={}
              ?Text(widget.datosUsuario['cedula'])
              :Text("cargando"),
              //trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.house_rounded),
              title: Text("Contrato"),
              subtitle: widget.datosUsuario!={}
              ?Text(widget.datosUsuario['contrato'])
              :Text("cargando"),
              //trailing: Icon(Icons.edit),
            ),
          ],
        ),
      );
  }
}