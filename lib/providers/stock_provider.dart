import 'package:flutter/cupertino.dart';
import 'package:soapp/database.dart';

import '../model/item_count_model.dart';

class StockProvider extends ChangeNotifier {
  List<ItemCount> itemCounts = [];

  List<ItemCount> itemNormal = [];
  List<ItemCount> itemNormalForDisplay = [];

  List<ItemCount> itemSelisih = [];
  List<ItemCount> itemSelisihForDisplay = [];

  List<ItemCount> itemBelumDihitung = [];
  List<ItemCount> itemBelumDihitungForDisplay = [];

  getItemCounts(int id) async {
    itemCounts = await Db().getItemCounts(id);
    itemBelumDihitung =
        itemCounts.where((element) => element.status == 0).toList();
    itemNormal = itemCounts
        .where((element) => element.selisih == 0 && element.status == 1)
        .toList();
    itemSelisih = itemCounts
        .where((element) => element.selisih != 0 && element.status == 1)
        .toList();

    itemNormalForDisplay = itemNormal;

    itemSelisihForDisplay = itemSelisih;

    itemBelumDihitungForDisplay = itemBelumDihitung;
    notifyListeners();
  }

  updateItemCounts(int id, ItemCount itemCount) async {
    await Db().updateItemCounts(itemCount);

    itemCounts = await Db().getItemCounts(id);
    itemBelumDihitung =
        itemCounts.where((element) => element.status == 0).toList();
    itemNormal = itemCounts
        .where((element) => element.selisih == 0 && element.status == 1)
        .toList();
    itemSelisih = itemCounts
        .where((element) => element.selisih != 0 && element.status == 1)
        .toList();

    itemNormalForDisplay = itemNormal;

    itemSelisihForDisplay = itemSelisih;

    itemBelumDihitungForDisplay = itemBelumDihitung;
    notifyListeners();
  }
}
