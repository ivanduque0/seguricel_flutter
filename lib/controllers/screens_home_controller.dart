import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ScreensHomeController extends GetxController{

  int _infoUsuarioScreen = 0;

  // RxInt infoUsuarioScreen=0.obs;

  int get infoUsuarioScreen=>_infoUsuarioScreen;

  // void cambiarScreen(int screen){
  //   // infoUsuarioScreen.value=screen;
  // }

  void cambiarScreen(int screen){
    _infoUsuarioScreen=screen;
    update();
    //print(_infoUsuarioScreen);
  }
  
}