import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Cuando vaya a ocupar el DB provider es muy probable que ocupe el mismo modelo del scan
// por eso lo exportamos tambien
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  // Propiedad estatica
  static Database? _database;
  // Contructor privado: "._"
  static final DBProvider db = DBProvider._();
  // Esto me ayuda a que cada vez que haga un new DBProvider siempre voy a obtener la misma instancia
  DBProvider._();

  Future<Database> get database async {
    //Esto es porque si ya lo he instanciado anteriormente quiero que devuelva la misma base de datos
    if (_database != null) {
      return _database!;
    } else {
      // Pero si es la primera vez ejecuta el metodo de iniciar una base de datos
      _database = await initDB();

      return _database!;
    }
  }

  Future<Database> initDB() async {
    // Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // El join nos ayuda a unir pedazos de path, para construir el url donde va a estar nuestra DB
    final path = join(documentsDirectory.path, 'ScansDB.db');
    // print(path);

    // Crear base de datos
    return await openDatabase(
      path,
      // Cuando cambio algo tengo que cambiar la version tambien
      version: 1,
      onOpen: (db) {},
      // Cuando se va a crear la base de datos
      onCreate: (Database db, int version) async {
        // String multilinea con 3 '''
        // Esto crea una tabla en SQL
        await db.execute('''
          CREATE TABLE Scans (
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          );
        ''');
      },
    );
  }

  // Las interacciones con la base de datos siempre son asincronas
  // Esto es una forma de hacer la insercion
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;
    // Verificar la base de datos
    final db = await database;

    final res = await db.rawInsert('''
       INSERT INTO Scans ( id, tipo, valor )
        VALUES ( ${id}, '$tipo', '$valor' )
    ''');
    return res;
  }

  // Esta es otra forma
  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    // El toJson toma la instancia de la clase y lo contruye como un mapa
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    // Aqui preguntamos si esta vacio o si tiene algo
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>?> getTodosLosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    // Aqui preguntamos si esta vacio o si tiene algo
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<ScanModel>?> getScanPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');

    // Aqui preguntamos si esta vacio o si tiene algo
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = db.update('Scans', nuevoScan.toJson(),
        where: 'id=?', whereArgs: [nuevoScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  // Con esto basta para borrar todo
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }

  // Esta es otra forma de borrar todo
  Future<int> deleteAllScans2() async {
    final db = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');
    return res;
  }
}
