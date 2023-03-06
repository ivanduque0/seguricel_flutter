import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PersonasVisitanteController extends GetxController{
  
  String _personas = "";

  // RxInt personascreen=0.obs;

  String get personas=>_personas;

  // void cambiarScreen(int screen){
  //   // personascreen.value=screen;
  // }

  void cambiarpersonas(String personass){
    _personas=personass;
    update();
    //print(_personas);
  }
  
}