import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ScreensUnidadController extends GetxController{

  int _unidadScreen = 0;

  // RxInt unidadScreen=0.obs;

  int get unidadScreen=>_unidadScreen;

  // void cambiarScreen(int screen){
  //   // unidadScreen.value=screen;
  // }

  void cambiarScreen(int screen){
    _unidadScreen=screen;
    update();
    //print(_unidadScreen);
  }
  
}