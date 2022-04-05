class Sesi {
  int? id;
  String? kodeSesi;
  String? tanggal;
  String? pic;

  Sesi({
    this.id,
    this.kodeSesi,
    this.tanggal,
    this.pic,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'kode_sesi': kodeSesi,
        'tanggal': tanggal,
        'pic': pic,
      };

  factory Sesi.fromJson(Map<String, dynamic> json) => Sesi(
        id: json['id'],
        kodeSesi: json['kode_sesi'],
        tanggal: json['tanggal'],
        pic: json['pic'],
      );
}
