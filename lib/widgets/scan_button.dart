import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: Icon(Icons.filter_center_focus),
      onPressed: () async {
        // Todo esto lo copiamos de la pagina del scanBarcode
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          // Color de la barrita
          '#3D8BEF',
          // Boton de cancelar
          'Cancelar',
          // Si queremos que se active el flash
          false,
          ScanMode.QR,
        );
        // print(barcodeScanRes);
        // final barcodeScanRes = 'http://solisem.com';
        // final barcodeScanRes = 'geo:-33.0499546,-69.2836974';

        if (barcodeScanRes == -1) {
          return;
        }

        // Esto quiere decir: busca en el arbol de widget la instancia del ScanListProvider
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        final nuevoScan = await scanListProvider.nuevoScan(barcodeScanRes);
        launchURL(context, nuevoScan);
      },
    );
  }
}
