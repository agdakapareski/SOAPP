import 'package:flutter/material.dart';
import 'package:soapp/database.dart';
import 'package:soapp/item_list.dart';
import 'package:soapp/widget/custom_button.dart';
import 'package:soapp/widget/input_form.dart';

import 'model/item_count_model.dart';

class DetailCountPage extends StatefulWidget {
  final int? index;
  final String? kodeItem;
  final String? namaItem;
  final String? kodeSesi;
  final int? carton;
  final int? box;
  final int? unit;
  final int? saldoItem;
  final int? hitung;

  const DetailCountPage(this.index, this.kodeItem, this.namaItem, this.kodeSesi,
      this.carton, this.box, this.unit, this.saldoItem, this.hitung,
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                title: const Text('carton'),
                onTap: () {
                  setState(() {
                    satuan = 'carton';
                    satuanFlag = 3;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: const Text('box'),
                onTap: () {
                  setState(() {
                    satuan = 'box';
                    satuanFlag = 2;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: const Text('unit'),
                onTap: () {
                  setState(() {
                    satuan = 'unit';
                    satuanFlag = 1;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ));
        });
  }

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
                  id: widget.index,
                  kodeItem: widget.kodeItem,
                  namaItem: widget.namaItem,
                  kodeSesi: widget.kodeSesi,
                  carton: widget.carton,
                  box: widget.box,
                  unit: widget.unit,
                  saldoItem: widget.saldoItem,
                  hitung: subtotal,
                  selisih: selisih,
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
          Row(
            children: [
              Expanded(
                flex: 6,
                child: InputForm(
                  labelText: 'jumlah item',
                  hintText: 'jumlah item',
                  controller: jumlahController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: satuan,
                  color: Colors.blueGrey,
                  onTap: () {
                    _showPicker(context);
                  },
                ),
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
                child: CustomButton(
                  text: 'Clear',
                  color: Colors.grey[700],
                  onTap: () {
                    setState(() {
                      subtotal = 0;
                      selisih = 0;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: CustomButton(
                  text: 'Tambah',
                  color: Colors.red[800],
                  onTap: () {
                    setState(() {
                      if (satuanFlag == 1) {
                        subtotal = subtotal + (int.parse(jumlahController.text) * widget.unit!);
                      } else if (satuanFlag == 2) {
                        subtotal = subtotal + (int.parse(jumlahController.text) * widget.box!);
                      } else {
                        subtotal = subtotal + (int.parse(jumlahController.text) * widget.carton!);
                      }
                      selisih = subtotal -  widget.saldoItem!;
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
