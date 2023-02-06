import 'package:flutter/material.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 75,
                child: CircleAvatar(
                  radius: 71,
                  backgroundImage: AssetImage("assets/images/gif_loading.gif"),
                )
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.orange,
                        width: 3),
                    ),
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.orange,
                        
                        
                      ),
                      child: Text("Espere por favor"),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
  }
}