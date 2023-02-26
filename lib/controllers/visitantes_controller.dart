import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class VisitantesController extends GetxController{
  
  List _visitantes = [];

  // RxInt visitanteScreen=0.obs;

  List get visitantes=>_visitantes;

  // void cambiarScreen(int screen){
  //   // visitanteScreen.value=screen;
  // }

  void cambiarVisitantes(List visitantess){
    _visitantes=visitantess;
    update();
    //print(_visitanteScreen);
  }
  
}