import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
  ));
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // const HomePage({super.key});
  var myText = "Change my name";
  TextEditingController _nameController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Seguricel",
          style: TextStyle(
            color: Colors.white
          ),
          ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                children: [
                  Image.asset(
                    "assets/seguricelbackground.jpg",
                  ),
                  SizedBox(
                    height: 20,
                    //child: Container(color: Colors.green,),
                  ),
                  Text(
                    myText, 
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                    //child: Container(color: Colors.green,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Ingresar codigo",
                        labelText: "Codigo",
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
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
        onPressed: () {
          myText = _nameController.text;
          setState(() {
            
          });
        },
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
