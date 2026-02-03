// models/denda_models.dart

class DendaModel {
  final int id;                    // id_denda — auto-increment, null saat insert
  final int? idPengembalian;       // FK ke pengembalian (nullable di schema)
  final int hariTerlambat;
  final int dendaPerHari;
  final int totalDenda;            // = hariTerlambat * dendaPerHari

  const DendaModel({
    required this.id,
    this.idPengembalian,
    required this.hariTerlambat,
    required this.dendaPerHari,
    required this.totalDenda,
  });

  // ─── dari row Supabase ────────────────────────────────────────────
  factory DendaModel.fromJson(Map<String, dynamic> json) {
    return DendaModel(
      id: json['id_denda'] as int,
      idPengembalian: json['id_pengembalian'] as int?,
      hariTerlambat: json['hari_terlambat'] as int,
      dendaPerHari: json['denda_per_hari'] as int,
      totalDenda: json['total_denda'] as int,
    );
  }

  // ─── untuk INSERT (tanpa id_denda, karena auto-increment) ─────────
  Map<String, dynamic> toInsertJson() {
    return {
      'id_pengembalian': idPengembalian,
      'hari_terlambat': hariTerlambat,
      'denda_per_hari': dendaPerHari,
      'total_denda': totalDenda,
    };
  }

  // ─── untuk UPDATE ─────────────────────────────────────────────────
  Map<String, dynamic> toUpdateJson() {
    return {
      'id_pengembalian': idPengembalian,
      'hari_terlambat': hariTerlambat,
      'denda_per_hari': dendaPerHari,
      'total_denda': totalDenda,
    };
  }
}