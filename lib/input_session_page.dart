import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soapp/database.dart';
import 'package:soapp/model/item_count_model.dart';
import 'package:soapp/providers/sesi_provider.dart';
import 'package:soapp/stock_count_page.dart';
import 'package:soapp/widget/custom_button.dart';
import 'package:soapp/widget/input_form.dart';
import 'package:soapp/widget/colors.dart';

import 'item_list.dart';
import 'model/sesi_model.dart';

class InputSessionPage extends StatefulWidget {
  const InputSessionPage({Key? key}) : super(key: key);

  @override
  State<InputSessionPage> createState() => _InputSessionPageState();
}

class _InputSessionPageState extends State<InputSessionPage> {
  TextEditingController tanggalController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(
      DateTime.parse(DateTime.now().toString()),
    ),
  );
  TextEditingController picController = TextEditingController();
  TextEditingController idController = TextEditingController();

  /// list untuk menyimpan data yang akan dihitung atau sudah dihitung
  List<ItemCount> itemCounts = [];

  List<ItemCount> itemCountsForDisplay = [];

  @override
  void initState() {
    // const _chars = '1234567890';
    // Random _rnd = Random.secure();
    //
    // String getRandomString(int length) =>
    //     String.fromCharCodes(Iterable.generate(
    //         length,
    //         (_) => _chars.codeUnitAt(
    //               _rnd.nextInt(_chars.length),
    //             )));

    DateTime now = DateTime.now();

    idController.text = 'SO-' + DateFormat('ddMMyyyykkmmss').format(now);

    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sesiProvider = Provider.of<SesiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Input Sesi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: warnaUtama,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InputForm(
            hintText: 'kode sesi',
            labelText: 'kode sesi',
            controller: idController,
            readonly: false,
          ),
          const SizedBox(
            height: 16,
          ),
          InputForm(
            hintText: 'tanggal',
            labelText: 'tanggal',
            controller: tanggalController,
            readonly: true,
          ),
          const SizedBox(
            height: 16,
          ),
          InputForm(
            hintText: 'pic',
            labelText: 'pic',
            controller: picController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
            color: warnaUtama,
            text: 'Input',
            onTap: () async {
              Sesi sesi = Sesi(
                kodeSesi: idController.text,
                pic: picController.text,
                tanggal: tanggalController.text,
              );

              int idS = sesiProvider.idSesi;
              idS = await sesiProvider.saveSesi(sesi);

              // Sesi s = Sesi(
              //     id: sesi.id,
              //     kodeSesi: sesi.kodeSesi,
              //     pic: sesi.pic,
              //     tanggal: sesi.tanggal);

              setState(() {
                // sessions.add(sesi);

                List<ItemCount> createItemCounts = [];
                for (var d in data) {
                  ItemCount itemCount = ItemCount(
                    idSesi: idS,
                    kodeItem: d.kodeItem,
                    namaItem: d.namaItem,
                    kodeSesi: idController.text,
                    carton: d.carton,
                    box: d.box,
                    unit: d.unit,
                    saldoItem: d.saldoItem,
                    hitung: 0,
                    selisih: 0 - d.saldoItem!,
                    status: 0,
                    keterangan: '-',
                  );
                  createItemCounts.add(itemCount);
                }

                Db().saveItemCounts(createItemCounts);

                Route route = MaterialPageRoute(
                  builder: (context) => StockCountPage(
                      sesi.id,
                      idController.text,
                      tanggalController.text,
                      picController.text),
                );
                Navigator.pushReplacement(context, route);
              });
            },
          )
        ],
      ),
    );
  }
}
