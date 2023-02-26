import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HorariosController extends GetxController{
  
  List _horarios = [];

  // RxInt horarioscreen=0.obs;

  List get horarios=>_horarios;

  // void cambiarScreen(int screen){
  //   // horarioscreen.value=screen;
  // }

  void cambiarhorarios(List horarioss){
    _horarios=horarioss;
    update();
    //print(_horarioscreen);
  }
  
}