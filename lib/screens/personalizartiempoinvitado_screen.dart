import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/utils/constants.dart';
import 'package:seguricel_flutter/utils/loading.dart';
import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

typedef void ScreenCallback(int id);

class PersonalizarTiempoInvitadoScreen extends StatefulWidget {
  // final ScreenCallback volver;
  // PersonalizarTiempoInvitadoScreen({required this.volver});

  @override
  State<PersonalizarTiempoInvitadoScreen> createState() => _PersonalizarTiempoInvitadoScreenState();
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min:00";
  }
}

class _PersonalizarTiempoInvitadoScreenState extends State<PersonalizarTiempoInvitadoScreen> {

  DateTime fechaEntrada = DateTime.now();
  DateTime fechaEntradaMinima = DateTime.now();
  DateTime fechaSalida = DateTime.now().add(Duration(days: 1));

  TimeOfDay entrada = TimeOfDay.now();
  TimeOfDay salida = TimeOfDay.now();

  String fechaDesde = "";
  String fechaHasta = "";
  String horaDesde = "";
  String horaHasta = "";

  bool cambiofechaDesde=false;
  bool cambiofechaHasta=false;
  bool cambiohoraDesde=false;
  bool cambiohoraHasta=false;

  ScreensVisitantesController controller = Get.find();

  DateTimeRange rangoFechas=DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // tiempoDefecto();
    
  }

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      controller.cambiarScreen(2);
      // widget.volver(2);
      return false;
    },
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text("INVITACION", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text("Entrada", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 187, 110),
                    borderRadius: BorderRadius.all(Radius.circular(21))
                  ),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              Text("Dia", 
                                style: TextStyle(
                                  color: !cambiofechaDesde
                                    ?Colors.black
                                    :Colors.green,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(DateFormat('dd/MM/yyyy').format(fechaEntrada), textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: !cambiofechaDesde
                                    ?Colors.black
                                    :Colors.green,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          onTap: () async{
                            DateTime? nuevaFechaEntrada = await showDatePicker(
                            context: context, 
                            initialDate: fechaEntrada, 
                            firstDate: fechaEntradaMinima, 
                            lastDate: fechaEntradaMinima.add(Duration(days: 5)));
                            if (nuevaFechaEntrada==null) return;
                            DateTime comprobarfechaentrada = DateTime.utc(nuevaFechaEntrada.year,nuevaFechaEntrada.month,nuevaFechaEntrada.day);
                            DateTime comprobarfechasalida = DateTime.utc(fechaSalida.year,fechaSalida.month,fechaSalida.day);
                            if (comprobarfechaentrada.isAfter(comprobarfechasalida) && !comprobarfechasalida.isAtSameMomentAs(comprobarfechaentrada)){
                              AwesomeDialog(
                                autoHide: Duration(seconds: 5) ,
                                titleTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red
                                ),
                                // descTextStyle: TextStyle(
                                //   fontWeight: FontWeight.bold,
                                //   fontSize: 20,
                                // ),
                                context: context,
                                animType: AnimType.topSlide,
                                headerAnimationLoop: false,
                                dialogType: DialogType.warning,
                                showCloseIcon: true,
                                title: "La fecha de entrada no puede ser mayor a la fecha de salida",
                                //desc:"Solicitud enviada",
                                btnOkColor: Color.fromARGB(255, 245, 195, 58),
                                btnOkOnPress: () {
                                  //debugPrint('OnClcik');
                                },
                                btnOkIcon: Icons.check_circle,
                                // onDismissCallback: (type) {
                                //   debugPrint('Dialog Dissmiss from callback $type');
                                // },
                              ).show();
                              return;
                            }
                            if (fechaDesde == "" || fechaHasta == "" || horaDesde == "" || horaHasta == ""){
                              setState(() {
                                fechaEntrada = nuevaFechaEntrada;
                                fechaDesde = DateFormat('yyyy-MM-dd').format(nuevaFechaEntrada);
                                fechaHasta = DateFormat('yyyy-MM-dd').format(fechaSalida);
                                horaDesde = entrada.to24hours();
                                horaHasta = salida.to24hours();
                                cambiofechaDesde=true;
                                // print(fechaDesde);
                                // print(fechaHasta);
                                // print(horaDesde);
                                // print(horaHasta);
                            });
                            }else{
                              setState(() {
                                cambiofechaDesde=true;
                                fechaEntrada = nuevaFechaEntrada;
                                fechaDesde = DateFormat('yyyy-MM-dd').format(nuevaFechaEntrada);
                              });
                            }
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            children: [
                              Text("Hora", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !cambiohoraDesde
                                    ?Colors.black
                                    :Colors.green,
                                  fontSize: 25
                                ),
                              ),
                              Text(entrada.format(context).toString(), 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !cambiohoraDesde
                                    ?Colors.black
                                    :Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          onTap: () async{
                            TimeOfDay? nuevaHoraEntrada = await showTimePicker(
                              context: context, 
                              initialTime: entrada);
                            if (nuevaHoraEntrada==null) return;
                            if (fechaDesde == "" || fechaHasta == "" || horaDesde == "" || horaHasta == ""){
                              setState(() {
                                entrada=nuevaHoraEntrada;
                                fechaDesde = DateFormat('yyyy-MM-dd').format(fechaEntrada);
                                fechaHasta = DateFormat('yyyy-MM-dd').format(fechaSalida);
                                horaDesde = nuevaHoraEntrada.to24hours();
                                horaHasta = salida.to24hours();
                                cambiohoraDesde=true;
                                // print(fechaDesde);
                                // print(fechaHasta);
                                // print(horaDesde);
                                // print(horaHasta);
                            });
                            }else{
                              setState(() {
                                entrada=nuevaHoraEntrada;
                                horaDesde = nuevaHoraEntrada.to24hours();
                              });
                            }
                          },
                        ),
                        // Text("Dia", 
                        //   style: TextStyle(
                        //     color: Colors.orange.shade200,
                        //     fontSize: 20
                        //   ),
                        // ),
                        // Text("Hora", 
                        //   style: TextStyle(
                        //     color: Colors.orange.shade200,
                        //     fontSize: 20
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Salida", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 187, 110),
                    borderRadius: BorderRadius.all(Radius.circular(21))
                  ),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              Text("Dia", 
                                style: TextStyle(
                                  color: !cambiofechaHasta
                                  ?Colors.black
                                  :Colors.green,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(DateFormat('dd/MM/yyyy').format(fechaSalida), textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: !cambiofechaHasta
                                  ?Colors.black
                                  :Colors.green,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          onTap: () async{
                            DateTime? nuevaFechaSalida = await showDatePicker(
                            context: context, 
                            initialDate: fechaSalida, 
                            firstDate: fechaEntradaMinima, 
                            lastDate: fechaEntradaMinima.add(Duration(days: 5)));
                            if (nuevaFechaSalida==null) return;
                            DateTime comprobarfechaentrada = DateTime.utc(fechaEntrada.year,fechaEntrada.month,fechaEntrada.day);
                            DateTime comprobarfechasalida = DateTime.utc(nuevaFechaSalida.year,nuevaFechaSalida.month,nuevaFechaSalida.day);
                            if (comprobarfechasalida.isBefore(comprobarfechaentrada) && !comprobarfechasalida.isAtSameMomentAs(comprobarfechaentrada)){
                              AwesomeDialog(
                                autoHide: Duration(seconds: 5) ,
                                titleTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red
                                ),
                                // descTextStyle: TextStyle(
                                //   fontWeight: FontWeight.bold,
                                //   fontSize: 20,
                                // ),
                                context: context,
                                animType: AnimType.topSlide,
                                headerAnimationLoop: false,
                                dialogType: DialogType.warning,
                                showCloseIcon: true,
                                title: "La fecha de salida no puede ser menor a la fecha de entrada",
                                //desc:"Solicitud enviada",
                                btnOkColor: Color.fromARGB(255, 245, 195, 58),
                                btnOkOnPress: () {
                                  //debugPrint('OnClcik');
                                },
                                btnOkIcon: Icons.check_circle,
                                // onDismissCallback: (type) {
                                //   debugPrint('Dialog Dissmiss from callback $type');
                                // },
                              ).show();
                              return;
                            }
                            if (fechaDesde == "" || fechaHasta == "" || horaDesde == "" || horaHasta == ""){
                              setState(() {
                                fechaSalida = nuevaFechaSalida;
                                fechaDesde = DateFormat('yyyy-MM-dd').format(fechaEntrada);
                                fechaHasta = DateFormat('yyyy-MM-dd').format(nuevaFechaSalida);
                                horaDesde = entrada.to24hours();
                                horaHasta = salida.to24hours();
                                cambiofechaHasta=true;
                                // print(fechaDesde);
                                // print(fechaHasta);
                                // print(horaDesde);
                                // print(horaHasta);
                            });
                            }else{
                              setState(() {
                                cambiofechaHasta=true;
                                fechaSalida = nuevaFechaSalida;
                                fechaHasta = DateFormat('yyyy-MM-dd').format(nuevaFechaSalida);
                              });
                            }
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            children: [
                              Text("Hora", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !cambiohoraHasta
                                    ?Colors.black
                                    :Colors.green,
                                  fontSize: 25
                                ),
                              ),
                              Text(salida.format(context).toString(), 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !cambiohoraHasta
                                    ?Colors.black
                                    :Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          onTap: () async{
                            TimeOfDay? nuevaHoraSalida = await showTimePicker(
                            context: context, 
                            initialTime: salida);
                          if (nuevaHoraSalida==null) return;
                          if (fechaDesde == "" || fechaHasta == "" || horaDesde == "" || horaHasta == ""){
                            setState(() {
                              salida=nuevaHoraSalida;
                              fechaDesde = DateFormat('yyyy-MM-dd').format(fechaEntrada);
                              fechaHasta = DateFormat('yyyy-MM-dd').format(fechaSalida);
                              horaDesde = entrada.to24hours();
                              horaHasta = nuevaHoraSalida.to24hours();
                              cambiohoraHasta=true;
                              // print(fechaDesde);
                              // print(fechaHasta);
                              // print(horaDesde);
                              // print(horaHasta);
                          });
                          }else{
                            setState(() {
                              cambiohoraHasta=true;
                              salida=nuevaHoraSalida;
                              horaHasta = nuevaHoraSalida.to24hours();
                            });
                          }
                          },
                        ),
                        // Text("Dia", 
                        //   style: TextStyle(
                        //     color: Colors.orange.shade200,
                        //     fontSize: 20
                        //   ),
                        // ),
                        // Text("Hora", 
                        //   style: TextStyle(
                        //     color: Colors.orange.shade200,
                        //     fontSize: 20
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            FloatingActionButton( 
              child: Icon(Icons.arrow_back_rounded, size: 40,),  
              onPressed: (() {
                // widget.volver(2);
                controller.cambiarScreen(2);
              }),
            ),
            SizedBox(
              width:MediaQuery.of(context).size.width/3,
            ),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                onPressed:(fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")
                ?null
                :() async {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: LoadingWidget());
                    }
                  );
                  String tiempoEstadiaInvitado= await jsonEncode({'fecha_entrada':fechaDesde, 'fecha_salida':fechaHasta, 'entrada':horaDesde, 'salida':horaHasta});
                  await Constants.prefs.setString('tiempoInvitado', tiempoEstadiaInvitado);
                  Navigator.of(context).pop();
                  // widget.volver(4);
                  controller.cambiarScreen(4);
                },
                child: Text("Continuar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 135, 253, 106), // Background color
                ),
              ),
            ),
            // OutlinedButton(
            //   style: OutlinedButton.styleFrom(
            //     fixedSize: Size(190, 50),
            //     foregroundColor: (fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")
            //                       ?Colors.grey
            //                       :Color.fromARGB(255, 125, 255, 74),
            //     //disabledForegroundColor: Colors.red,
            //     side: BorderSide(color: (fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")
            //                           ?Colors.grey
            //                           :Color.fromARGB(255, 125, 255, 74), width: 3),
            //   ),
            //   onPressed:(fechaDesde=="" && fechaHasta =="" && horaDesde=="" && horaHasta=="")? null : (){widget.volver(0);},
            //   child: Text("Continuar", style: TextStyle(fontSize: 18))
            // )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    )
  );


  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   /// The argument value will return the changed date as [DateTime] when the
  //   /// widget [SfDateRangeSelectionMode] set as single.
  //   ///
  //   /// The argument value will return the changed dates as [List<DateTime>]
  //   /// when the widget [SfDateRangeSelectionMode] set as multiple.
  //   ///
  //   /// The argument value will return the changed range as [PickerDateRange]
  //   /// when the widget [SfDateRangeSelectionMode] set as range.
  //   ///
  //   /// The argument value will return the changed ranges as
  //   /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
  //   /// multi range.
  //   setState(() {
  //     if (args.value is PickerDateRange) {
  //       fechaDesde = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
  //       fechaHasta = ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
  //     }
  //   });
  // }

//   Widget getDateRangePicker() {
//   return Container(
//       height: 280,
//       child: Card(
//           child: SfDateRangePicker(
//                     onSelectionChanged: _onSelectionChanged,
//                     selectionMode: DateRangePickerSelectionMode.range,
//                     initialSelectedRange: PickerDateRange(
//                         DateTime.now(),
//                         DateTime.now().add(const Duration(days: 1))),
//                   ),));
// }
//   Future pickDateRange() async {
//     DateTimeRange? nuevoRangoFechas = await showDateRangePicker(
//       context: context, 
//       initialDateRange: rangoFechas,
//       firstDate: DateTime.now(), 
//       lastDate: DateTime.now().add(const Duration(days: 5)));

//     if (nuevoRangoFechas==null) return;
//     fechaDesde = '${DateFormat('yyyy-MM-dd').format(nuevoRangoFechas.start)}';
//     fechaHasta = ' ${DateFormat('yyyy-MM-dd').format(nuevoRangoFechas.end)}';
//     print(fechaDesde);
//     print(fechaHasta);
//     setState(() {
//       rangoFechas=DateTimeRange(start: nuevoRangoFechas.start, end: nuevoRangoFechas.end);
//     });
//   }



}