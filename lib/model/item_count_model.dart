import 'dart:convert';

class ItemCount {
  int? id;
  String? kodeItem;
  String? namaItem;
  String? idSesi;
  int? carton;
  int? box;
  int? unit;
  int? saldoItem;
  int? hitung;
  int? selisih;

  ItemCount({
    this.id,
    this.kodeItem,
    this.namaItem,
    this.idSesi,
    this.carton,
    this.box,
    this.unit,
    this.saldoItem,
    this.hitung,
    this.selisih,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'kode_item': kodeItem,
        'nama_item': namaItem,
        'id_sesi': idSesi,
        'carton': carton,
        'box': box,
        'unit': unit,
        'saldo_item': saldoItem,
        'hitung': hitung,
        'selisih': selisih,
      };

  factory ItemCount.fromJson(Map<String, dynamic> json) => ItemCount(
    id: json['id'],
    kodeItem: json['kode_item'],
    namaItem: json['nama_item'],
    idSesi: json['id_sesi'],
    carton: json['carton'],
    box: json['box'],
    unit: json['unit'],
    saldoItem: json['saldo_item'],
    hitung: json['hitung'],
    selisih: json['selisih'],
  );
}
