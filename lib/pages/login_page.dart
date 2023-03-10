import 'package:flutter/material.dart';
import 'package:seguricel_flutter/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //const LoginPage({super.key});
  final formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  //final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login page"),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/seguricelbackground.jpg", 
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Ingrese su codigo",
                              labelText: "Codigo"
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // TextFormField(
                          //   controller: _passwordController,
                          //   keyboardType: TextInputType.text,
                          //   obscureText: true,
                          //   decoration: InputDecoration(
                          //     hintText: "Ingrese contrase??a",
                          //     labelText: "Contrase??a"
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Constants.prefs?.setBool("loggedIn", true);
                              // Navigator.push(
                              //   context, 
                              //   MaterialPageRoute(
                              //     builder: ((context) => MainPage())));
                              Navigator.pushNamed(context, MainPage.routeName);
                            }, 
                            child: Text("Ingresar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}