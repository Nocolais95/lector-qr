import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_reader/models/scan_model.dart';
// import 'package:qr_reader/pages/historial_mapas_page.dart';
import 'package:qr_reader/pages/home_page.dart';

class MapaPage extends StatefulWidget {
  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  // Creamos esta propiedad para poder modificarla a gusto
  MapType mapType = MapType.normal;
  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;
    final prueba = scan.getLatLng();
    print(prueba);
    final CameraPosition _puntoInicial = CameraPosition(
      target: prueba,
      zoom: 17,
    );

    // Agregar un marcador
    Set<Marker> markers = new Set<Marker>();
    markers.add(new Marker(
        markerId: MarkerId('geo-location'), position: scan.getLatLng()));

    if (prueba != LatLng(90.0, -80.0)) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mapa'),
          actions: [
            IconButton(
              icon: Icon(Icons.location_searching_sharp),
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_puntoInicial));
              },
            )
          ],
        ),
        body: GoogleMap(
          zoomControlsEnabled: false,
          markers: markers,
          mapType: mapType,
          initialCameraPosition: _puntoInicial,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.layers),
          onPressed: () {
            if (mapType == MapType.normal) {
              mapType = MapType.satellite;
            } else {
              mapType = MapType.normal;
            }
            setState(() {});
          },
        ),
      );
    } else {
      return HomePage();
    }
  }
}
