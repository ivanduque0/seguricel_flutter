import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:seguricel_flutter/controllers/apertura_visitante_controller.dart';
import 'package:seguricel_flutter/controllers/codigo_visitante_controller.dart';
import 'package:seguricel_flutter/controllers/contrato_controller.dart';
import 'package:seguricel_flutter/controllers/personas_visitante_controller.dart';
import 'package:seguricel_flutter/controllers/screens_visitantes_controller.dart';
import 'package:seguricel_flutter/utils/scanner_error_widget.dart';

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWithControllerState createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController>
    with SingleTickerProviderStateMixin {
  //BarcodeCapture? barcode;
  CodigoVisitanteController codigoVisitanteController = Get.find();
  ContratoController contratoController = Get.find();
  AperturaVisitanteController aperturaVisitanteController = Get.find();
  PersonasVisitanteController personasVisitanteController = Get.find();
  ScreensVisitantesController screensVisitantesController = Get.put(ScreensVisitantesController());

  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    // detectionTimeoutMs: 1000,
    // returnImage: false,
  );

  bool isStarted = true;

  void _startOrStop() {
    try {
      if (isStarted) {
        controller.stop();
      } else {
        controller.start();
      }
      setState(() {
        isStarted = !isStarted;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hubo un problema $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                errorBuilder: (context, error, child) {
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.contain,
                onDetect: (barcode) async {
                  if(barcode.barcodes.first.rawValue!=null){
                    codigoVisitanteController.cambiarCodigo(barcode.barcodes.first.rawValue??""); 
                    _startOrStop();
                    Get.back();  
                  }
                  // setState(() {
                  //   this.barcode = barcode;
                  // });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: controller.hasTorchState,
                        builder: (context, state, child) {
                          if (state != true) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            color: Colors.white,
                            icon: ValueListenableBuilder(
                              valueListenable: controller.torchState,
                              builder: (context, state, child) {
                                if (state == null) {
                                  return const Icon(
                                    Icons.flash_off,
                                    color: Colors.grey,
                                  );
                                }
                                switch (state as TorchState) {
                                  case TorchState.off:
                                    return const Icon(
                                      Icons.flash_off,
                                      color: Colors.grey,
                                    );
                                  case TorchState.on:
                                    return const Icon(
                                      Icons.flash_on,
                                      color: Colors.yellow,
                                    );
                                }
                              },
                            ),
                            iconSize: 32.0,
                            onPressed: () => controller.toggleTorch(),
                          );
                        },
                      ),
                      // IconButton(
                      //   color: Colors.white,
                      //   icon: isStarted
                      //       ? const Icon(Icons.stop)
                      //       : const Icon(Icons.play_arrow),
                      //   iconSize: 32.0,
                      //   onPressed: _startOrStop,
                      // ),
                      // Center(
                      //   child: SizedBox(
                      //     width: MediaQuery.of(context).size.width - 200,
                      //     height: 50,
                      //     child: FittedBox(
                      //       child: Text(
                      //         barcode?.barcodes.first.rawValue ??
                      //             'Coloque el codigo QR en la pantalla',
                      //         overflow: TextOverflow.fade,
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headlineMedium!
                      //             .copyWith(color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: controller.cameraFacingState,
                          builder: (context, state, child) {
                            if (state == null) {
                              return const Icon(Icons.camera_front);
                            }
                            switch (state as CameraFacing) {
                              case CameraFacing.front:
                                return const Icon(Icons.camera_front);
                              case CameraFacing.back:
                                return const Icon(Icons.camera_rear);
                            }
                          },
                        ),
                        iconSize: 32.0,
                        onPressed: () => controller.switchCamera(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}