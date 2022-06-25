class Histori {
  int? id;
  int? idItem;
  int? jumlah;
  String? satuan;

  Histori({
    this.id,
    this.idItem,
    this.jumlah,
    this.satuan,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_item': idItem,
        'jumlah': jumlah,
        'satuan': satuan,
      };

  factory Histori.fromJson(Map<String, dynamic> json) => Histori(
        id: json['id'],
        idItem: json['id_item'],
        jumlah: json['jumlah'],
        satuan: json['satuan'],
      );
}
