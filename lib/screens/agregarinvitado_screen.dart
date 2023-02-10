import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

typedef void ScreenCallback(int id);

class AgregarInvitadoScreen extends StatefulWidget {
  final ScreenCallback volver;
  AgregarInvitadoScreen({required this.volver});

  @override
  State<AgregarInvitadoScreen> createState() => _AgregarInvitadoScreenState();
}

class _AgregarInvitadoScreenState extends State<AgregarInvitadoScreen> {

  String fechaDesde = '';
  String fechaHasta = '';

  @override
  Widget build(BuildContext context) => WillPopScope(

    onWillPop: () async {
      widget.volver(0);
      return false;
    },
    child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              //Navigator.pushNamed(context, EntrarPage.routeName);
            }, // Handle your callback.
            splashColor: Color.fromARGB(255, 116, 168, 245).withOpacity(0.5),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
              fixedSize: Size(150, 70),
              foregroundColor: Color.fromARGB(255, 116, 168, 245),
              //disabledForegroundColor: Colors.red,
              side: BorderSide(color: Colors.blue, width: 3),
            ),
              onPressed: (() {
              setState(() {
                  
                  // print("state 3");
                });
              }), 
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3,
                child: Center(
                  child: Text("Seleccione la fecha", textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),),
                ),
                // child: Image.network("https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg"),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20)
                  
                // ),
              ),
            ),
            // Ink(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height/3,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     image: DecorationImage(
            //       image: NetworkImage('https://http2.mlstatic.com/D_NQ_NP_909774-MLV52690599466_122022-W.jpg'),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
          ),
          // MaterialButton(
          //   child: Container(
          //   ),
          //   onPressed: () {
          //     showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //               title: Text(''),
          //               content: Container(
          //                 height: 350,
          //                 child: Column(
          //                   children: <Widget>[
          //                     getDateRangePicker(),
          //                     MaterialButton(
          //                       child: Text("OK"),
          //                       onPressed: () {
          //                         print(fechaDesde);
          //                         print(fechaHasta);
          //                         Navigator.pop(context);
          //                       },
          //                     )
          //                   ],
          //                 ),
          //               ));
          //         });
          //   },
          // ),
        ],
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Center(
      //     child: Column(
      //       children: [
      //         Container(
      //           child: Column(
      //             children: [
      //               SizedBox(
      //                 height: 20,
      //               ),
      //               Text('Seleccione el tiempo de estadia de su invitado', 
      //               textAlign: TextAlign.center, 
      //               style: TextStyle(
      //                 fontSize: 30,
      //                 fontWeight: FontWeight.bold
      //               ),
      //               ),
      //               SizedBox(
      //                 height: 60,
      //               ),
      //               Text('Actualmente no tiene invitados', 
      //               textAlign: TextAlign.center, 
      //               style: TextStyle(
      //                 fontSize: 30,
      //                 fontWeight: FontWeight.bold
      //               ),
      //               ),
      //             ],
      //           )
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton( 
          child: Icon(Icons.arrow_back_rounded, size: 40,),  
          onPressed: (() {
            widget.volver(0);
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
    )
  );


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        fechaDesde = '${DateFormat('yyyy/MM/dd').format(args.value.startDate)} -';
        fechaHasta = ' ${DateFormat('yyyy/MM/dd').format(args.value.endDate ?? args.value.startDate)}';
      }
    });
  }

  Widget getDateRangePicker() {
  return Container(
      height: 280,
      child: Card(
          child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  ),));
}
}