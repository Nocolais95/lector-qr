import 'package:flutter/cupertino.dart';
import 'package:qr_reader/providers/db_provider.dart';

// Este Scan va a actualizar la interfaz de usuario
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  Future<ScanModel> nuevoScan(String valor) async {
    final nuevoScan = new ScanModel(valor: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScan);
    // Asignar el ID de la base de datos al modelo
    nuevoScan.id = id;
    // Insertar este nuevo scan a la lista de scans
    if (this.tipoSeleccionado == nuevoScan.tipo) {
      this.scans.add(nuevoScan);
      // Usamos el notify para notificar a cualquier widget cuando esto cambia
      notifyListeners();
    }
    return nuevoScan;
  }

  cargarScans() async {
    final scans = await DBProvider.db.getTodosLosScans();
    // Recuperador express de los scans que esten ahi
    this.scans = [...scans!];
    notifyListeners();
  }

  cargarScansPorTipo(String tipo) async {
    final scans = await DBProvider.db.getScanPorTipo(tipo);
    this.scans = [...scans!];
    this.tipoSeleccionado = tipo;
    notifyListeners();
  }

  borrarTodos() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  borrarScanPorId(int id) async {
    await DBProvider.db.deleteScan(id);
    // No hay que llamar al notify porque ya esta llamado en el metodo de arriba
  }
}
