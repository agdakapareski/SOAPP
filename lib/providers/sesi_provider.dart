import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:soapp/database.dart';

import '../model/sesi_model.dart';

class SesiProvider extends ChangeNotifier {
  List<Sesi> sessions = [];
  int idSesi = 0;

  getSesi() async {
    sessions = await Db().getSesi();
    notifyListeners();
  }

  deleteSesi(int id) async {
    await Db().deleteSesi(id);

    sessions = await Db().getSesi();
    notifyListeners();
  }

  saveSesi(Sesi sesi) async {
    int? id;
    id = await Db().saveSesi(sesi);
    sessions = await Db().getSesi();
    notifyListeners();
    return id;
  }
}
