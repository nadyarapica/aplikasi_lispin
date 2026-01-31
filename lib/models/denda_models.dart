class DendaModel {
  final int? idDenda;
  final int idPengembalian;
  final int hariTerlambat;
  final int dendaPerHari;
  final int totalDenda;

  DendaModel({
    this.idDenda,
    required this.idPengembalian,
    required this.hariTerlambat,
    required this.dendaPerHari,
    required this.totalDenda,
  });

  // Convert from JSON (dari Supabase)
  factory DendaModel.fromJson(Map<String, dynamic> json) {
    return DendaModel(
      idDenda: json['id_denda'] as int?,
      idPengembalian: json['id_pengembalian'] as int,
      hariTerlambat: json['hari_terlambat'] as int,
      dendaPerHari: json['denda_per_hari'] as int,
      totalDenda: json['total_denda'] as int,
    );
  }

  // Convert to JSON (untuk insert/update ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (idDenda != null) 'id_denda': idDenda,
      'id_pengembalian': idPengembalian,
      'hari_terlambat': hariTerlambat,
      'denda_per_hari': dendaPerHari,
      'total_denda': totalDenda,
    };
  }

  // Convert to JSON tanpa id (untuk insert)
  Map<String, dynamic> toJsonForInsert() {
    return {
      'id_pengembalian': idPengembalian,
      'hari_terlambat': hariTerlambat,
      'denda_per_hari': dendaPerHari,
      'total_denda': totalDenda,
    };
  }

  // Copy with method (untuk update partial data)
  DendaModel copyWith({
    int? idDenda,
    int? idPengembalian,
    int? hariTerlambat,
    int? dendaPerHari,
    int? totalDenda,
  }) {
    return DendaModel(
      idDenda: idDenda ?? this.idDenda,
      idPengembalian: idPengembalian ?? this.idPengembalian,
      hariTerlambat: hariTerlambat ?? this.hariTerlambat,
      dendaPerHari: dendaPerHari ?? this.dendaPerHari,
      totalDenda: totalDenda ?? this.totalDenda,
    );
  }

  @override
  String toString() {
    return 'DendaModel(idDenda: $idDenda, idPengembalian: $idPengembalian, hariTerlambat: $hariTerlambat, dendaPerHari: $dendaPerHari, totalDenda: $totalDenda)';
  }
}