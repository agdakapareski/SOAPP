import 'package:flutter/cupertino.dart';
import 'package:soapp/database.dart';
import 'package:soapp/model/histori_model.dart';

class HistoriProvider extends ChangeNotifier {
  List<Histori> historis = [];

  getHistori(int idItem) async {
    historis = await Db().getHistori(idItem);
    notifyListeners();
  }

  saveHistori(Histori histori, int idItem) async {
    await Db().saveHistori(histori);
    historis = await Db().getHistori(idItem);
    notifyListeners();
  }

  deleteHistori(int idItem) async {
    await Db().deleteHistori(idItem);
    historis = await Db().getHistori(idItem);
    notifyListeners();
  }
}
