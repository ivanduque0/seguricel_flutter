import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AperturaVisitanteController extends GetxController{
  
  bool _visitante = false;

  // RxInt visitanteScreen=0.obs;

  bool get visitante=>_visitante;

  // void cambiarScreen(int screen){
  //   // visitanteScreen.value=screen;
  // }

  void cambiarVisitante(bool visitantee){
    _visitante=visitantee;
    update();
    //print(_visitanteScreen);
  }
  
}