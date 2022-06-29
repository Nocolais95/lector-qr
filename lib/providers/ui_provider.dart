import 'package:flutter/cupertino.dart';

// Hay que notificar a cualquier widget que este escuchando cuando esto cambie
// Por eso se usa el Change Notifier
class UiProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;
  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int i) {
    this._selectedMenuOpt = i;
    notifyListeners();
  }
}
