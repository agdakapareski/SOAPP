import 'package:flutter/material.dart';
import 'package:soapp/input_session_page.dart';
import 'package:soapp/item_list.dart';
import 'package:soapp/stock_count_page.dart';

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

  /// list untuk menyimpan sesi
  List<Sesi> sessions = [];

  // widget untuk memberi jarak antar widget
  final Widget objectPadding = const SizedBox(
    height: 18,
  );

  Widget fix(String text) {
    return Text(text);
  }

  @override
  void initState() {
    Db().getSesi().then((value) {
      setState(() {
        sessions.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judulPage.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: warnaUtama,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () async {
                sessions = await Db().getSesi();
                setState(() {});
              },
              child: const Icon(Icons.update),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route =
              MaterialPageRoute(builder: (context) => const InputSessionPage());
          Navigator.push(context, route);
        },
        backgroundColor: Colors.red[800],
        child: const Icon(Icons.add),
      ),
      body: ListView(
          children: sessions.map((session) {
        var index = sessions.indexOf(session);
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
                  setState(() {
                    sessions.removeAt(index);
                    Db().deleteSesi(session.id!);
                  });
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
