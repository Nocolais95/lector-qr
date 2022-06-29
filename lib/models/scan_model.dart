import 'dart:convert';

// Solo lo vamos a usar para una cosa por eso ponemos el show
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));
String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  ScanModel({
    this.id,
    this.tipo,
    required this.valor,
  }) {
    if (this.valor.contains("http")) {
      this.tipo = 'http';
    } else {
      this.tipo = 'geo';
    }
  }

  int? id;
  String? tipo;
  String valor;

  // Esto viene en el paquete de google maps
  LatLng getLatLng() {
    String latLng = 'ca';
    double lat = 1000000;
    double lng = 1000000;

    // Esto crea un arreglo donde la primera posicion es la latitud y la segunda es la longitud, separadas por coma
    if (valor.length >= 3) {
      latLng = valor.substring(4).split(',') as String;
      lat = double.parse(latLng[0]);
      lng = double.parse(latLng[1]);
      return LatLng(lat, lng);
    } else {
      return LatLng(lat, lng);
    }
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
      };
}
