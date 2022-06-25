import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soapp/detail_count_page.dart';
import 'package:soapp/database.dart';
import 'package:soapp/providers/stock_provider.dart';
import 'package:soapp/widget/input_form.dart';

import 'package:permission_handler/permission_handler.dart';

import 'dart:io';

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
  /// controller search
  TextEditingController searchController = TextEditingController();

  // /// list semua item yang akan dilakukan stock opname
  // List<ItemCount> itemCounts = [];

  // /// list item yang tidak selisih - setelah dihitung
  // List<ItemCount> itemNormal = [];
  // List<ItemCount> itemNormalForDisplay = [];

  // /// list item yang selisih - setelah dihitung
  // List<ItemCount> itemSelisih = [];
  // List<ItemCount> itemSelisihForDisplay = [];

  // /// list item yang belum dihitung
  // List<ItemCount> itemBelumDihitung = [];
  // List<ItemCount> itemBelumDihitungForDisplay = [];

  /// penanda tab[Belum dihitung, Selesai, Selisih] yang sedang aktif
  int kolomFlag = 1;
  bool isKode = false;

  @override
  void initState() {
    /// mengambil data dari database
    // Db().getItemCounts(widget.idSesi!).then((value) {
    //   setState(() {
    //     itemCounts.addAll(value);
    //     // print('itemCounts: ${itemCounts.length}');
    //     itemBelumDihitung =
    //         itemCounts.where((element) => element.status == 0).toList();
    //     // print('itemNormal: ${itemNormal.length}');
    //     itemNormal = itemCounts
    //         .where((element) => element.selisih == 0 && element.status == 1)
    //         .toList();
    //     // print('itemNormal: ${itemNormal.length}');
    //     itemSelisih = itemCounts
    //         .where((element) => element.selisih != 0 && element.status == 1)
    //         .toList();
    //     // print('itemSelisih: ${itemSelisih.length}');
    //     itemNormalForDisplay = itemNormal;
    //     // print('itemNormalForDisplay: ${itemNormalForDisplay.length}');
    //     itemSelisihForDisplay = itemSelisih;
    //     // print('itemSelisihForDisplay: ${itemSelisihForDisplay.length}');
    //     itemBelumDihitungForDisplay = itemBelumDihitung;
    //     // print('display belum dihitung: ${itemBelumDihitung.length}');
    //   });
    // });
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    stockProvider.getItemCounts(widget.idSesi!);
    super.initState();
  }

  /// Fungsi untuk generate data file yang sudah dihitung
  /// menjadi file .csv dan disimpan dalam folder download
  generateCsv() async {
    /// list untuk menampung data yang akan di convert ke .csv
    List<List<String>> data = [];

    /// memasukkan header
    data.add(
        ["KODE", "NAMA", "SALDO", "HASIL HITUNGAN", "SELISIH", "KETERANGAN"]);

    /// memasukkan data item ke dalam list
    List<ItemCount> combine = await Db().getItemCounts(widget.idSesi!);
    for (var i in combine) {
      data.add([
        i.kodeItem!,
        i.namaItem!,
        i.saldoItem.toString(),
        i.hitung.toString(),
        i.selisih.toString(),
        i.keterangan ?? '-',
      ]);
    }

    /// format csv yang akan di export
    String csvData =
        const ListToCsvConverter(fieldDelimiter: ';').convert(data);

    /// Direktori file csv
    Directory directory = Directory("/storage/emulated/0/Download");
    final path = "${directory.path}/${widget.kodeSesi}-${widget.pic}.csv";
    // print(path);
    final File file = File(path);
    // ignore: unused_local_variable
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    await file.writeAsString(csvData);

    /// snackbar notifikasi jika simpan csv berhasil
    var snackBar = const SnackBar(
      content: Text('Export .csv Berhasil!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hitung Stock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[800],
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                generateCsv();
              },
              child: const Icon(Icons.download),
            ),
          ),
        ],
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
                    children: [
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: [
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
                          ],
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       List<ItemCount> itemsNormal = [];
                      //       List<ItemCount> itemsSelisih = [];
                      //       List<ItemCount> itemsBelumDihitung = [];

                      //       itemBelumDihitung =
                      //           await Db().getItemCounts(widget.idSesi!);
                      //       itemsBelumDihitung = itemBelumDihitung
                      //           .where((element) => element.status == 0)
                      //           .toList();
                      //       itemNormal =
                      //           await Db().getItemCounts(widget.idSesi!);
                      //       itemsNormal = itemNormal
                      //           .where((element) =>
                      //               element.selisih == 0 && element.status == 1)
                      //           .toList();
                      //       itemSelisih =
                      //           await Db().getItemCounts(widget.idSesi!);
                      //       itemsSelisih = itemSelisih
                      //           .where((element) =>
                      //               element.selisih != 0 && element.status == 1)
                      //           .toList();
                      //       setState(() {
                      //         itemNormalForDisplay = itemsNormal;
                      //         itemSelisihForDisplay = itemsSelisih;
                      //         itemBelumDihitungForDisplay = itemsBelumDihitung;
                      //       });

                      //       return Future.delayed(
                      //           const Duration(milliseconds: 500));
                      //     },
                      //     child: Icon(
                      //       Icons.refresh,
                      //       size: 35,
                      //       color: Colors.red[800],
                      //     ),
                      //   ),
                      // )
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
                            // List<ItemCount> itemCategory = [];
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
                                'BELUM DIHITUNG',
                                style: TextStyle(
                                  fontSize: 12,
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
                            // List<ItemCount> itemCategory = [];
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
                                'SELESAI',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kolomFlag == 2
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
                            // List<ItemCount> itemCategory = [];
                            setState(() {
                              kolomFlag = 3;
                              // print(kolomFlag);
                            });
                          },
                          child: Container(
                            color: kolomFlag == 3
                                ? Colors.red[800]
                                : Colors.grey[50],
                            height: 50,
                            child: Center(
                              child: Text(
                                'SELISIH',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kolomFlag == 3
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
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          isKode = !isKode;
                        });
                      },
                      child: Text(
                        'kode',
                        style: TextStyle(
                          color: isKode ? Colors.red[800] : Colors.black,
                        ),
                      ),
                    ),
                    labelText: 'search',
                    hintText: 'search',
                    controller: searchController,
                    onChanged: (text) {
                      if (kolomFlag == 1) {
                        if (isKode == false) {
                          text = text.toLowerCase();
                          setState(() {
                            stockProvider.itemBelumDihitungForDisplay =
                                stockProvider.itemBelumDihitung
                                    .where((element) {
                              var itemTitle = element.namaItem!.toLowerCase();
                              return itemTitle.contains(text);
                            }).toList();
                          });
                        } else {
                          text = text.toLowerCase();
                          setState(() {
                            stockProvider.itemBelumDihitungForDisplay =
                                stockProvider.itemBelumDihitung
                                    .where((element) {
                              var itemTitle = element.kodeItem!.toLowerCase();
                              return itemTitle.contains(text);
                            }).toList();
                          });
                        }
                      } else if (kolomFlag == 2) {
                        if (isKode == false) {
                          text = text.toLowerCase();
                          setState(() {
                            stockProvider.itemNormalForDisplay =
                                stockProvider.itemNormal.where((element) {
                              var itemTitle = element.namaItem!.toLowerCase();
                              return itemTitle.contains(text);
                            }).toList();
                          });
                        } else {
                          text = text.toLowerCase();
                          setState(() {
                            stockProvider.itemNormalForDisplay =
                                stockProvider.itemNormal.where((element) {
                              var itemTitle = element.kodeItem!.toLowerCase();
                              return itemTitle.contains(text);
                            }).toList();
                          });
                        }
                      } else {
                        if (isKode == false) {
                          text = text.toLowerCase();
                          setState(() {
                            stockProvider.itemSelisihForDisplay =
                                stockProvider.itemSelisih.where((element) {
                              var itemTitle = element.namaItem!.toLowerCase();
                              return itemTitle.contains(text);
                            }).toList();
                          });
                        } else {
                          text = text.toLowerCase();
                          setState(() {
                            stockProvider.itemSelisihForDisplay =
                                stockProvider.itemSelisih.where((element) {
                              var itemTitle = element.kodeItem!.toLowerCase();
                              return itemTitle.contains(text);
                            }).toList();
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 5),
              shrinkWrap: true,
              children: kolomFlag == 1
                  ? stockProvider.itemBelumDihitungForDisplay
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
                                    item.status,
                                    item.keterangan,
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
                                  fontWeight: FontWeight.bold,
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
                  : (kolomFlag == 2
                      ? stockProvider.itemNormalForDisplay
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
                                        item.status,
                                        item.keterangan,
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
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.namaItem!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          // overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text('keterangan: ${item.keterangan}'),
                                    ],
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
                      : stockProvider.itemSelisihForDisplay
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
                                        item.status,
                                        item.keterangan,
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
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.namaItem!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          // overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text('keterangan: ${item.keterangan}'),
                                    ],
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
                          .toList()),
            ),
          ),
        ],
      ),
    );
  }
}
