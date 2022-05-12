import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soapp/input_session_page.dart';
import 'package:soapp/item_list.dart';
import 'package:soapp/providers/sesi_provider.dart';
import 'package:soapp/stock_count_page.dart';
import 'package:soapp/widget/confirm_dialog.dart';

import 'database.dart';
import 'model/sesi_model.dart';

class CountPage extends StatefulWidget {
  const CountPage({Key? key}) : super(key: key);

  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  // text judul page
  String judulPage = 'stock opname';

  // warna utama aplikasi
  final Color? warnaUtama = Colors.red[800];

  // controller saldo
  TextEditingController unitController = TextEditingController(text: '0');

  // controller unit / karton
  TextEditingController kartonController = TextEditingController(text: '0');

  // controller unit / box
  TextEditingController boxController = TextEditingController(text: '0');

  // /// list untuk menyimpan sesi
  // List<Sesi> sessions = [];

  // widget untuk memberi jarak antar widget
  final Widget objectPadding = const SizedBox(
    height: 18,
  );

  Widget fix(String text) {
    return Text(text);
  }

  @override
  void initState() {
    // Db().getSesi().then((value) {
    //   setState(() {
    //     sessions.addAll(value);
    //   });
    // });

    final sesiProvider = Provider.of<SesiProvider>(context, listen: false);
    sesiProvider.getSesi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sesiProvider = Provider.of<SesiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judulPage.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: warnaUtama,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     child: GestureDetector(
        //       onTap: () async {
        //         sessions = await Db().getSesi();
        //         setState(() {});
        //       },
        //       child: const Icon(Icons.update),
        //     ),
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (data.isEmpty) {
            var snackBar = const SnackBar(
              content: Text('Upload Master Data Terlebih Dahulu!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            Route route = MaterialPageRoute(
                builder: (context) => const InputSessionPage());
            Navigator.push(context, route);
          }
        },
        backgroundColor: Colors.red[800],
        child: const Icon(Icons.add),
      ),
      body: ListView(
          children: sesiProvider.sessions.map((session) {
        return Column(
          children: [
            ListTile(
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) => StockCountPage(
                    session.id,
                    session.kodeSesi,
                    session.tanggal,
                    session.pic,
                  ),
                );
                Navigator.push(context, route);
              },
              tileColor: Colors.white,
              title: Text(session.kodeSesi.toString()),
              subtitle: Text(session.tanggal! + ' - ' + session.pic!),
              trailing: GestureDetector(
                onTap: () {
                  confirmDialog(
                    title: 'Konfirmasi',
                    confirmation: 'Apakah anda yakin ingin menghapus sesi ini?',
                    context: context,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              sesiProvider.deleteSesi(session.id!);
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
                child: Icon(
                  Icons.delete,
                  color: Colors.red[800],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        );
      }).toList()),
    );
  }
}
