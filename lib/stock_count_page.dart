import 'package:flutter/material.dart';
import 'package:soapp/detail_count_page.dart';
import 'package:soapp/database.dart';
import 'package:soapp/widget/input_form.dart';

import 'item_list.dart';
import 'model/item_count_model.dart';

class StockCountPage extends StatefulWidget {
  final int? idSesi;
  final String? kodeSesi;
  final String? tanggalSesi;
  final String? pic;

  const StockCountPage(this.idSesi, this.kodeSesi, this.tanggalSesi, this.pic,
      {Key? key})
      : super(key: key);

  @override
  State<StockCountPage> createState() => _StockCountPageState();
}

class _StockCountPageState extends State<StockCountPage> {
  TextEditingController searchController = TextEditingController();

  List<ItemCount> itemCounts = [];

  List<ItemCount> itemNormalForDisplay = [];

  List<ItemCount> itemSelisihForDisplay = [];

  List<ItemCount> itemSelisih = [];

  List<ItemCount> itemNormal = [];

  int kolomFlag = 1;

  @override
  void initState() {
    Db().getItemCounts(widget.idSesi!).then((value) {
      setState(() {
        itemCounts.addAll(value);
        itemNormal =
            itemCounts.where((element) => element.selisih == 0).toList();
        // print('itemNormal: ${itemNormal.length}');
        itemSelisih =
            itemCounts.where((element) => element.selisih != 0).toList();
        // print('itemSelisih: ${itemSelisih.length}');
        itemNormalForDisplay = itemNormal;
        // print('itemNormalForDisplay: ${itemNormalForDisplay.length}');
        itemSelisihForDisplay = itemSelisih;
        // print('itemSelisihForDisplay: ${itemSelisihForDisplay.length}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hitung Stock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[800],
        elevation: 0,
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     child: GestureDetector(
        //       onTap: () {},
        //       child: const Icon(Icons.download),
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.kodeSesi!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tanggal :'),
                      Text(widget.tanggalSesi!),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('pic :'),
                      Text(widget.pic!),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            List<ItemCount> itemCategory = [];
                            setState(() {
                              kolomFlag = 1;
                              // print(kolomFlag);
                            });
                          },
                          child: Container(
                            color: kolomFlag == 1
                                ? Colors.red[800]
                                : Colors.grey[50],
                            height: 50,
                            child: Center(
                              child: Text(
                                'normal',
                                style: TextStyle(
                                  color: kolomFlag == 1
                                      ? Colors.grey[50]
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            List<ItemCount> itemCategory = [];
                            setState(() {
                              kolomFlag = 2;
                              // print(kolomFlag);
                            });
                          },
                          child: Container(
                            color: kolomFlag == 2
                                ? Colors.red[800]
                                : Colors.grey[50],
                            height: 50,
                            child: Center(
                              child: Text(
                                'selisih',
                                style: TextStyle(
                                  color: kolomFlag == 2
                                      ? Colors.grey[50]
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputForm(
                    labelText: 'search',
                    hintText: 'search',
                    controller: searchController,
                    onChanged: (text) {
                      if (kolomFlag == 1) {
                        text = text.toLowerCase();
                        setState(() {
                          itemNormalForDisplay = itemNormal.where((element) {
                            var itemTitle = element.namaItem!.toLowerCase();
                            return itemTitle.contains(text);
                          }).toList();
                        });
                      } else {
                        text = text.toLowerCase();
                        setState(() {
                          itemSelisihForDisplay = itemSelisih.where((element) {
                            var itemTitle = element.namaItem!.toLowerCase();
                            return itemTitle.contains(text);
                          }).toList();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                List<ItemCount> items = [];
                if (kolomFlag == 1) {
                  itemNormal = await Db().getItemCounts(widget.idSesi!);
                  items = itemNormal
                      .where((element) => element.selisih == 0)
                      .toList();
                  setState(() {
                    itemNormalForDisplay = items;
                  });
                  return Future.delayed(const Duration(milliseconds: 500));
                } else {
                  itemSelisih = await Db().getItemCounts(widget.idSesi!);
                  items = itemSelisih
                      .where((element) => element.selisih != 0)
                      .toList();
                  setState(() {
                    itemSelisihForDisplay = items;
                  });
                  return Future.delayed(const Duration(milliseconds: 500));
                }
              },
              child: ListView(
                padding: const EdgeInsets.only(top: 5),
                shrinkWrap: true,
                children: kolomFlag == 1
                    ? itemNormalForDisplay
                        .where((element) => element.idSesi == widget.idSesi)
                        .map(
                          (item) => Column(
                            children: [
                              ListTile(
                                isThreeLine: true,
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (context) => DetailCountPage(
                                      item.id,
                                      widget.idSesi,
                                      item.kodeItem,
                                      item.namaItem,
                                      item.kodeSesi,
                                      item.carton,
                                      item.box,
                                      item.unit,
                                      item.saldoItem,
                                      item.hitung,
                                    ),
                                  );

                                  Navigator.push(context, route);
                                },
                                tileColor: Colors.white,
                                title: Row(
                                  children: [
                                    Text(
                                      item.kodeItem.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' - Saldo: ${item.saldoItem}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  item.namaItem!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                    // overflow: TextOverflow.ellipsis
                                  ),
                                ),
                                trailing:
                                Text('${item.hitung} (${item.selisih})'),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        )
                        .toList()
                    : itemSelisihForDisplay
                        .where((element) => element.idSesi == widget.idSesi)
                        .map(
                          (item) => Column(
                            children: [
                              ListTile(
                                isThreeLine: true,
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (context) => DetailCountPage(
                                      item.id,
                                      widget.idSesi,
                                      item.kodeItem,
                                      item.namaItem,
                                      item.kodeSesi,
                                      item.carton,
                                      item.box,
                                      item.unit,
                                      item.saldoItem,
                                      item.hitung,
                                    ),
                                  );

                                  Navigator.push(context, route);
                                },
                                tileColor: Colors.white,
                                title: Row(
                                  children: [
                                    Text(
                                      item.kodeItem.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' - Saldo: ${item.saldoItem}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  item.namaItem!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                    // overflow: TextOverflow.ellipsis
                                  ),
                                ),
                                trailing:
                                    Text('${item.hitung} (${item.selisih})'),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
