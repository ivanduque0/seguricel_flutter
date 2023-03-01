import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ContratoController extends GetxController{
  
  String _contrato = "";

  // RxInt contratocreen=0.obs;

  String get contrato=>_contrato;

  // void cambiarScreen(int screen){
  //   // contratocreen.value=screen;
  // }

  void cambiarContrato(String contratoo){
    _contrato=contratoo;
    update();
    //print(_contrato);
  }
  
}