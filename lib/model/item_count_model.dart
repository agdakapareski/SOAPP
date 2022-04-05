
class ItemCount {
  int? id;
  int? idSesi;
  String? kodeItem;
  String? namaItem;
  String? kodeSesi;
  int? carton;
  int? box;
  int? unit;
  int? saldoItem;
  int? hitung;
  int? selisih;

  ItemCount({
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
    this.selisih,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_sesi': idSesi,
        'kode_item': kodeItem,
        'nama_item': namaItem,
        'kode_sesi': kodeSesi,
        'carton': carton,
        'box': box,
        'unit': unit,
        'saldo_item': saldoItem,
        'hitung': hitung,
        'selisih': selisih,
      };

  factory ItemCount.fromJson(Map<String, dynamic> json) => ItemCount(
    id: json['id'],
    idSesi: json['id_sesi'],
    kodeItem: json['kode_item'],
    namaItem: json['nama_item'],
    kodeSesi: json['kode_sesi'],
    carton: json['carton'],
    box: json['box'],
    unit: json['unit'],
    saldoItem: json['saldo_item'],
    hitung: json['hitung'],
    selisih: json['selisih'],
  );
}
