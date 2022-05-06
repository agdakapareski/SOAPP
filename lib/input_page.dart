import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soapp/session_page.dart';
import 'package:soapp/widget/custom_button.dart';
import 'widget/input_form.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  // text judul page
  final String judulPage = 'tambah item';

  // warna utama aplikasi
  final Color? warnaUtama = Colors.red[800];

  // controller nama item
  TextEditingController namaItemController = TextEditingController();

  // controller saldo
  TextEditingController saldoController = TextEditingController(text: '0');

  // controller unit / karton
  TextEditingController unitPerKartonController =
      TextEditingController(text: '0');

  // controller unit / box
  TextEditingController unitPerBoxController = TextEditingController(text: '0');

  Widget fix(String text) {
    return Text(text);
  }

  // widget untuk memberi jarak antar widget
  final Widget objectPadding = const SizedBox(
    height: 18,
  );

  // fungsi untuk kembali ke halaman sebelumnya
  void kembali() {
    Navigator.pop(context);
  }

  // fungsi untuk menuju ke halaman stock opname
  void keStockOpname() {
    Route route = CupertinoPageRoute(
      builder: (context) => const CountPage(),
    );

    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judulPage.toUpperCase()),
        elevation: 0,
        centerTitle: true,
        backgroundColor: warnaUtama,
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 18,
        ),
        children: [
          InputForm(
            labelText: 'nama item',
            hintText: 'nama item',
            controller: namaItemController,
            textCapitalization: TextCapitalization.words,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Nama item tidak boleh kosong!';
              }
              return null;
            },
          ),
          objectPadding,
          InputForm(
            labelText: 'saldo',
            hintText: 'saldo',
            controller: saldoController,
            suffix: fix('unit'),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Saldo tidak boleh kosong!';
              }
              return null;
            },
          ),
          objectPadding,
          InputForm(
            labelText: 'unit / karton',
            hintText: 'unit / karton',
            controller: unitPerKartonController,
            suffix: fix('unit'),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'unit tidak boleh kosong!';
              }
              return null;
            },
          ),
          objectPadding,
          InputForm(
            labelText: 'unit / box',
            hintText: 'unit / box',
            controller: unitPerBoxController,
            suffix: fix('unit'),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'unit tidak boleh kosong!';
              }
              return null;
            },
          ),
          objectPadding,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  color: Colors.grey,
                  text: 'Kembali',
                  onTap: kembali,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: CustomButton(
                  color: warnaUtama,
                  text: 'Teruskan',
                  onTap: keStockOpname,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
