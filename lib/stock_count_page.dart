import 'package:flutter/material.dart';
import 'package:soapp/detail_count_page.dart';
import 'package:soapp/widget/input_form.dart';

import 'item_list.dart';

class StockCountPage extends StatefulWidget {
  final String? idSesi;
  final String? tanggalSesi;
  final String? pic;

  const StockCountPage(this.idSesi, this.tanggalSesi, this.pic, {Key? key})
      : super(key: key);

  @override
  State<StockCountPage> createState() => _StockCountPageState();
}

class _StockCountPageState extends State<StockCountPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {

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
                    widget.idSesi!,
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
                      const Text('PIC :'),
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
              onRefresh: () {
                setState(() {});
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
                                  itemCounts.indexOf(item),
                                  item.kodeItem,
                                  item.namaItem,
                                  item.idSesi,
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
