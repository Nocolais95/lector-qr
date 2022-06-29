import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/historial_mapas_page.dart';

import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

import 'package:qr_reader/widgets/custom_navigatorbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Como ya se dijo, si no esta dentro de un build hay que poner el listen en false
              // Aca el provider esta dentro de un metodo, asique en false
              Provider.of<ScanListProvider>(context, listen: false)
                  .borrarTodos();
            },
            icon: Icon(Icons.delete_forever),
          )
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el selected menu opt
    final uiProvider = Provider.of<UiProvider>(context);

    // Cambiar para mostrar la pag respectiva
    final currentIndex = uiProvider.selectedMenuOpt;

    // TODO: Temporal leer la base de datos para evaluar lo que hacemos
    // final tempScan = ScanModel(valor: 'http://google.com');
    // DBProvider.db.nuevoScan(tempScan);
    // DBProvider.db.getScanById(76).then((scan) => print(scan!.valor));
    // DBProvider.db.deleteAllScans().then(print);

    // Usar el ScanListProvider
    // No queremos que se redibuje en este momento por eso el listen en false
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo('geo');
        return HistorialMapasPage();
      case 1:
        scanListProvider.cargarScansPorTipo('http');
        return DireccionesPage();

      default:
        return HistorialMapasPage();
    }
  }
}
