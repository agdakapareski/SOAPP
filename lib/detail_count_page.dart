import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soapp/model/histori_model.dart';
import 'package:soapp/providers/histori_provider.dart';

import 'package:soapp/providers/stock_provider.dart';
import 'package:soapp/widget/confirm_dialog.dart';
import 'package:soapp/widget/custom_button.dart';
import 'package:soapp/widget/input_form.dart';
import 'package:soapp/widget/colors.dart';

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
  final int? status;
  final String? keterangan;

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
      this.status,
      this.keterangan,
      {Key? key})
      : super(key: key);

  @override
  State<DetailCountPage> createState() => _DetailCountPageState();
}

class _DetailCountPageState extends State<DetailCountPage> {
  TextEditingController jumlahController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();

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
    if (widget.keterangan != '-') {
      setState(() {
        keteranganController.text = widget.keterangan ?? '-';
      });
    }
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
    final historiProvider =
        Provider.of<HistoriProvider>(context, listen: false);
    if (widget.status == 0) {
      historiProvider.deleteHistori(widget.id!);
      historiProvider.getHistori(widget.id!);
    } else {
      historiProvider.getHistori(widget.id!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final historiProvider = Provider.of<HistoriProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: warnaUtama,
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
                  keterangan: keteranganController.text == ''
                      ? '-'
                      : keteranganController.text,
                );

                setState(() {
                  stockProvider.updateItemCounts(widget.idSesi!, item);
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
              const Text('Keterangan :'),
              Text(widget.keterangan ?? '-'),
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
                        color: satuanFlag == 3 ? warnaUtama : Colors.white,
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
                        color: satuanFlag == 2 ? warnaUtama : Colors.white,
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
                        color: satuanFlag == 1 ? warnaUtama : Colors.white,
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
              ),
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
                                historiProvider.deleteHistori(widget.id!);
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: warnaUtama,
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
                                    color: warnaUtama,
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
                  color: warnaUtama,
                  onTap: () {
                    Histori h = Histori();
                    setState(() {
                      if (jumlahController.text != '') {
                        if (satuanFlag == 1) {
                          subtotal = subtotal +
                              (int.parse(jumlahController.text) * widget.unit!);
                          h.satuan = 'unit';
                        } else if (satuanFlag == 2) {
                          subtotal = subtotal +
                              (int.parse(jumlahController.text) * widget.box!);
                          h.satuan = 'box';
                        } else {
                          subtotal = subtotal +
                              (int.parse(jumlahController.text) *
                                  widget.carton!);
                          h.satuan = 'carton';
                        }
                        selisih = subtotal - widget.saldoItem!;
                        historiProvider.saveHistori(
                          Histori(
                            idItem: widget.id,
                            jumlah: int.parse(jumlahController.text),
                            satuan: h.satuan,
                          ),
                          widget.id!,
                        );
                        jumlahController.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                      } else {
                        return;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          InputForm(
            labelText: 'keterangan',
            hintText: 'keterangan',
            controller: keteranganController,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 60,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: historiProvider.historis.isNotEmpty
                  ? historiProvider.historis
                      .map(
                        (histori) => Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 60,
                            color: Colors.grey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  histori.jumlah! > 0
                                      ? '+${histori.jumlah}'
                                      : histori.jumlah.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  histori.satuan!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList()
                  : [const Text('...')],
            ),
          ),
        ],
      ),
    );
  }
}
