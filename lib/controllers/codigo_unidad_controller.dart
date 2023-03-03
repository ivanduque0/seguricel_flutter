import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CodigoUnidadController extends GetxController{
  
  String _codigo = "";

  // RxInt codigocreen=0.obs;

  String get codigo=>_codigo;

  // void cambiarScreen(int screen){
  //   // codigocreen.value=screen;
  // }

  void cambiarCodigo(String codigoo){
    _codigo=codigoo;
    update();
    //print(_codigo);
  }
  
}