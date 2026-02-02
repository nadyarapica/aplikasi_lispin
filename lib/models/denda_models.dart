class DendaModel {
  final int id;
  final int? idPengembalian;
  final int hariTerlambat;
  final int dendaPerHari;
  final int totalDenda;

  DendaModel({
    required this.id,
    this.idPengembalian,
    required this.hariTerlambat,
    required this.dendaPerHari,
    required this.totalDenda,
  });

  factory DendaModel.fromJson(Map<String, dynamic> json) {
    return DendaModel(
      id: json['id_denda'] as int,
      idPengembalian: json['id_pengembalian'] as int?,
      hariTerlambat: json['hari_terlambat'] as int? ?? 0,
      dendaPerHari: json['denda_per_hari'] as int? ?? 0,
      totalDenda: json['total_denda'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_denda': id,
      'id_pengembalian': idPengembalian,
      'hari_terlambat': hariTerlambat,
      'denda_per_hari': dendaPerHari,
      'total_denda': totalDenda,
    };
  }

  // Helper untuk insert (tanpa id)
  Map<String, dynamic> toInsertJson() {
    return {
      'id_pengembalian': idPengembalian,
      'hari_terlambat': hariTerlambat,
      'denda_per_hari': dendaPerHari,
      'total_denda': totalDenda,
    };
  }
}