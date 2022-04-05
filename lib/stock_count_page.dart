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

  List<ItemCount> itemCountsForDisplay = [];

  @override
  void initState() {
    Db().getItemCounts().then((value) {
      setState(() {
        itemCounts.addAll(value);
        itemCountsForDisplay = itemCounts;
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
                    height: 5,
                  ),
                  InputForm(
                    labelText: 'search',
                    hintText: 'search',
                    controller: searchController,
                    onChanged: (text) {
                      text = text.toLowerCase();
                      setState(() {
                        itemCountsForDisplay = itemCounts.where((element) {
                          var itemTitle = element.namaItem!.toLowerCase();
                          return itemTitle.contains(text);
                        }).toList();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                itemCounts = await Db().getItemCounts();
                setState(() {
                  itemCountsForDisplay = itemCounts;
                });
                return Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView(
                padding: const EdgeInsets.only(top: 5),
                shrinkWrap: true,
                children: itemCountsForDisplay
                    .where((element) => element.idSesi == widget.idSesi)
                    .map(
                      (item) => Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (context) => DetailCountPage(
                                  item.id,
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
                                Text(item.kodeItem.toString()),
                                Text(
                                  ' - Saldo: ${item.saldoItem}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(item.namaItem!),
                            trailing: Text('${item.hitung} (${item.selisih})'),
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
