class Sesi {
  int? id;
  String? idSesi;
  String? tanggal;
  String? PIC;

  Sesi({
    this.id,
    this.idSesi,
    this.tanggal,
    this.PIC,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_sesi': idSesi,
        'tanggal': tanggal,
        'pic': PIC,
      };

  factory Sesi.fromJson(Map<String, dynamic> json) => Sesi(
        id: json['id'],
        idSesi: json['id_sesi'],
        tanggal: json['tanggal'],
        PIC: json['pic'],
      );
}
