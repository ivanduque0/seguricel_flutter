import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ScreensVisitantesController extends GetxController{

  int _visitanteScreen = 0;

  // RxInt visitanteScreen=0.obs;

  int get visitanteScreen=>_visitanteScreen;

  // void cambiarScreen(int screen){
  //   // visitanteScreen.value=screen;
  // }

  void cambiarScreen(int screen){
    _visitanteScreen=screen;
    update();
    //print(_visitanteScreen);
  }
  
}