import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;

  const ScanTiles({required this.tipo});

  @override
  Widget build(BuildContext context) {
    // Aca si necesitams que el listen este en true, siempre es true adentro de un build
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;
    return ListView.builder(
      itemCount: scans.length,
      // El Dismissible permite borrar el item  para los costados
      itemBuilder: (_, i) => Dismissible(
        // El UniqueKey crea un key unico por nosotros
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .borrarScanPorId(scans[i].id!);
        },
        child: ListTile(
            leading: Icon(
              this.tipo == 'http' ? Icons.home_outlined : Icons.map_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(scans[i].valor),
            subtitle: Text(scans[i].id.toString()),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () => launchURL(context, scans[i])),
      ),
    );
  }
}
