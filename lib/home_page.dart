import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soapp/item_list.dart';
import 'package:soapp/model/item_model.dart';
import 'package:soapp/widget/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// judul aplikasi yang terletak pada app bar
  /// -> kemungkinan bakal dihilangkan
  String judulApp = 'SOAPP';

  /// alamat file yang akan dipilih untuk dimuat ke aplikasi
  String? path;

  /// warna utama aplikasi
  /// -> kemungkinan masih diganti ke kode warna yang lebih spesifik
  final Color? warnaUtama = Colors.red[800];

  /// style section judul
  final TextStyle styleJudul = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  /* 
  fungsi untuk memuat file dari storage
  -> file csv masih harus template, tidak semua csv bisa masuk 
  */
  loadCsvFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    setState(() {
      path = result!.files.first.path;
      loadingCsvData(path!);
    });
  }

  /* 
  memuat file csv yang sudah dipilih dan di convert ke list
  -> convert ke list 2 dimensi, lalu di convert lagi ke List<Item> 
  */
  loadingCsvData(String path) async {
    final csvFile = File(path).openRead();
    List<List<dynamic>> master = await csvFile
        .transform(utf8.decoder)
        .transform(
          const CsvToListConverter(eol: '\n', fieldDelimiter: ';'),
        )
        .toList();
    print(master);
    print(master.length);

    /* 
    menghapus index yang memuat header
    [
       ['no', 'nama', 'carton', 'box', 'unit', 'saldo'], <- menghilangkan index ini, karena header tidak diperlukan disini
       [1, 'konidin', 30, 10, 1, 234],
       [2, 'boom', 20, 5, 1, 300],
       ...
    ] 
    */
    master.removeAt(0);
    master.join(',');

    /// tampungan sementara hasil konversi csv
    List<Item> i = [];

    /* 
    convert list 2 dimensi menjadi list Item
    semula =  [
                [1, 'konidin', 30, 10, 1, 234],
                [2, 'boom', 20, 5, 1, 300],
                ...
              ]
    
    menjadi = [
                Item(kodeItem: 1, namaItem: 'konidin', carton: 30, box: 10, unit: 1, saldoItem: 234),
                Item(kodeItem: 2, namaItem: 'boom', carton: 20, box: 5, unit: 1, saldoItem: 300),
                ...
              ]   
    */
    for (var item in master) {
      Item a = Item(
        kodeItem: item[0],
        namaItem: item[1],
        carton: item[2].runtimeType == String ? int.parse(item[2]) : item[2],
        box: item[3].runtimeType == String ? int.parse(item[3]) : item[3],
        unit: item[4].runtimeType == String ? int.parse(item[4]) : item[4],
        saldoItem: item[5].runtimeType == String ? int.parse(item[5]) : item[5],
      );

      setState(() {
        i.add(a);
      });
    }

    if (data.isNotEmpty) {
      data = [];
      data.addAll(i);
    } else {
      data.addAll(i);
    }
    // print(data[0].carton.runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judulApp,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        elevation: 0,
        backgroundColor: warnaUtama,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  data = [];
                });
              },
              child: const Icon(Icons.delete),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: CustomButton(
              text: 'Upload Master Produk',
              onTap: () {
                loadCsvFromStorage();
              },
              color: Colors.red[800],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: data
                  .map(
                    (item) => Column(
                      children: [
                        ListTile(
                          isThreeLine: true,
                          tileColor: Colors.white,
                          title: Text(item.kodeItem.toString()),
                          subtitle: Text(item.namaItem!),
                          trailing: Text(item.saldoItem.toString()),
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
        ],
      ),
    );
  }
}
