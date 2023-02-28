import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class RolController extends GetxController{
  
  String _rol="Secundario";

  // RxInt bottomBar=0.obs;

  String get rol=>_rol;

  // void cambiarScreen(int screen){
  //   // bottomBar.value=screen;
  // }

  void cambiarrol(String roll){
    _rol=roll;
    update();
    //print(_rol);
  }
  
}