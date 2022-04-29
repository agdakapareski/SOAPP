import 'package:flutter/material.dart';
import 'package:soapp/database.dart';
import 'package:soapp/item_list.dart';
import 'package:soapp/widget/confirm_dialog.dart';
import 'package:soapp/widget/custom_button.dart';
import 'package:soapp/widget/input_form.dart';

import 'model/item_count_model.dart';

class DetailCountPage extends StatefulWidget {
  final int? id;
  final int? idSesi;
  final String? kodeItem;
  final String? namaItem;
  final String? kodeSesi;
  final int? carton;
  final int? box;
  final int? unit;
  final int? saldoItem;
  final int? hitung;

  const DetailCountPage(
      this.id,
      this.idSesi,
      this.kodeItem,
      this.namaItem,
      this.kodeSesi,
      this.carton,
      this.box,
      this.unit,
      this.saldoItem,
      this.hitung,
      {Key? key})
      : super(key: key);

  @override
  State<DetailCountPage> createState() => _DetailCountPageState();
}

class _DetailCountPageState extends State<DetailCountPage> {
  TextEditingController jumlahController = TextEditingController();

  int subtotal = 0;

  int selisih = 0;

  String satuan = 'unit';

  int satuanFlag = 1;

  // void _showPicker(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return SafeArea(
  //             child: Wrap(
  //           children: [
  //             ListTile(
  //               title: const Text('carton'),
  //               onTap: () {
  //                 setState(() {
  //                   satuan = 'carton';
  //                   satuanFlag = 3;
  //                   Navigator.pop(context);
  //                 });
  //               },
  //             ),
  //             ListTile(
  //               title: const Text('box'),
  //               onTap: () {
  //                 setState(() {
  //                   satuan = 'box';
  //                   satuanFlag = 2;
  //                   Navigator.pop(context);
  //                 });
  //               },
  //             ),
  //             ListTile(
  //               title: const Text('unit'),
  //               onTap: () {
  //                 setState(() {
  //                   satuan = 'unit';
  //                   satuanFlag = 1;
  //                   Navigator.pop(context);
  //                 });
  //               },
  //             ),
  //           ],
  //         ));
  //       });
  // }

  @override
  void initState() {
    if (widget.hitung == 0) {
      setState(() {
        selisih = subtotal - widget.saldoItem!;
      });
    } else {
      setState(() {
        subtotal = widget.hitung!;
        selisih = subtotal - widget.saldoItem!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[800],
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                ItemCount item = ItemCount(
                  id: widget.id,
                  idSesi: widget.idSesi,
                  kodeItem: widget.kodeItem,
                  namaItem: widget.namaItem,
                  kodeSesi: widget.kodeSesi,
                  carton: widget.carton,
                  box: widget.box,
                  unit: widget.unit,
                  saldoItem: widget.saldoItem,
                  hitung: subtotal,
                  selisih: selisih,
                  status: 1,
                );
                setState(() {
                  Db().updateItemCounts(item);
                  Navigator.pop(context);
                });
              },
              child: const Icon(Icons.done),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        children: [
          Text(
            '${widget.namaItem}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kode Item :'),
              Text(widget.kodeItem!),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kode Sesi :'),
              Text(widget.kodeSesi!),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Master Data',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Unit / Karton :'),
              Text('${widget.carton!}'),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Unit / Box :'),
              Text('${widget.box!}'),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Unit :'),
              Text('${widget.unit!}'),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Saldo :'),
              Text('${widget.saldoItem!}'),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$subtotal',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Selisih :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$selisih',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              InputForm(
                labelText: 'jumlah item',
                hintText: 'jumlah item',
                controller: jumlahController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          satuanFlag = 3;
                        });
                      },
                      child: Container(
                        color: satuanFlag == 3 ? Colors.red[800] : Colors.white,
                        height: 50,
                        child: Center(
                          child: Text(
                            'carton',
                            style: TextStyle(
                              color: satuanFlag == 3
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
                        setState(() {
                          satuanFlag = 2;
                        });
                      },
                      child: Container(
                        color: satuanFlag == 2 ? Colors.red[800] : Colors.white,
                        height: 50,
                        child: Center(
                          child: Text(
                            'box',
                            style: TextStyle(
                              color: satuanFlag == 2
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
                        setState(() {
                          satuanFlag = 1;
                        });
                      },
                      child: Container(
                        color: satuanFlag == 1 ? Colors.red[800] : Colors.white,
                        height: 50,
                        child: Center(
                          child: Text(
                            'unit',
                            style: TextStyle(
                              color: satuanFlag == 1
                                  ? Colors.grey[50]
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    confirmDialog(
                      title: 'Konfirmasi',
                      confirmation: 'Apakah anda yakin ingin menghapus data?',
                      context: context,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                subtotal = 0;
                                selisih = subtotal - widget.saldoItem!;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red[800],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  'Hapus',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  'batal',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Container(
                    height: 55.9,
                    color: Colors.grey[700],
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 5,
                child: CustomButton(
                  text: 'Tambah',
                  color: Colors.red[800],
                  onTap: () {
                    setState(() {
                      if (satuanFlag == 1) {
                        subtotal = subtotal +
                            (int.parse(jumlahController.text) * widget.unit!);
                      } else if (satuanFlag == 2) {
                        subtotal = subtotal +
                            (int.parse(jumlahController.text) * widget.box!);
                      } else {
                        subtotal = subtotal +
                            (int.parse(jumlahController.text) * widget.carton!);
                      }
                      selisih = subtotal - widget.saldoItem!;
                      jumlahController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
