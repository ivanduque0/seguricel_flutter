import 'package:flutter/material.dart';
import 'package:seguricel_flutter/archivospractica6/drawer.dart';
import 'package:seguricel_flutter/archivospractica6/name_card_widget.dart';
import 'package:http_auth/http_auth.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // const HomePage({super.key});
  // var myText = "Change my name";
  // TextEditingController _nameController = TextEditingController();
  
  // var url= Uri(
  //   scheme: 'https',
  //   host: 'webseguricel.up.railway.app',
  //   path: '/dispositivosapimobile/754/');
  var url = Uri.parse('https://webseguricel.up.railway.app/dispositivosapimobile/orangepii96/');
  var data;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  

  fetchData()async{
    //print(this.url);
    var client = BasicAuthClient('mobile_access', 'S3gur1c3l_mobile@');
    var res = await client.post(url);
    data = jsonDecode(res.body);
    setState(() {
      
    });
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
      body: data!=null
      ?ListView.builder(
        itemBuilder: (context, index){
          return ListTile(
            title: Text(data[index]["descripcion"]),
            subtitle: Text("URL: ${data[index]["dispositivo"]}"),
            leading: Icon(Icons.device_hub),
          );
        },
        itemCount: data.length,
      )
      :Center(
        child: CircleAvatar(
          backgroundColor: Colors.orange,
          radius: 75,
          child: CircleAvatar(
            radius: 71,
            backgroundImage: AssetImage("assets/gif_loading.gif"),
          )
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

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
