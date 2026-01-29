class AlatModel {
  final int idAlat;
  final String namaAlat;
  final int? idKategori;
  final String? namaKategori;
  final String kondisi;
  final int stok;
  final String? gambarAlat;
  final String? gambarUrl;

  AlatModel({
    required this.idAlat,
    required this.namaAlat,
    this.idKategori,
    this.namaKategori,
    required this.kondisi,
    required this.stok,
    this.gambarAlat,
    this.gambarUrl,
  });

  factory AlatModel.fromMap(Map<String, dynamic> map) {
    return AlatModel(
      idAlat: map['id_alat'] ?? 0,
      namaAlat: map['nama_alat']?.toString() ?? '',
      idKategori: map['id_kategori'] as int?,
      namaKategori: map['kategori']?['nama_kategori']?.toString(),
      kondisi: map['kondisi']?.toString() ?? 'Baik',
      stok: map['stok'] ?? 0,
      gambarAlat: map['gambar_alat']?.toString(),
      gambarUrl: map['gambar_url']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_alat': idAlat,
      'nama_alat': namaAlat,
      'id_kategori': idKategori,
      'kondisi': kondisi,
      'stok': stok,
      'gambar_alat': gambarAlat,
    };
  }

  @override
  String toString() {
    return 'AlatModel{id: $idAlat, nama: $namaAlat, stok: $stok, kondisi: $kondisi}';
  }

  AlatModel copyWith({
    int? idAlat,
    String? namaAlat,
    int? idKategori,
    String? namaKategori,
    String? kondisi,
    int? stok,
    String? gambarAlat,
    String? gambarUrl,
  }) {
    return AlatModel(
      idAlat: idAlat ?? this.idAlat,
      namaAlat: namaAlat ?? this.namaAlat,
      idKategori: idKategori ?? this.idKategori,
      namaKategori: namaKategori ?? this.namaKategori,
      kondisi: kondisi ?? this.kondisi,
      stok: stok ?? this.stok,
      gambarAlat: gambarAlat ?? this.gambarAlat,
      gambarUrl: gambarUrl ?? this.gambarUrl,
    );
  }
}

class KategoriDropdown {
  final int idKategori;
  final String namaKategori;

  KategoriDropdown({
    required this.idKategori,
    required this.namaKategori,
  });

  factory KategoriDropdown.fromMap(Map<String, dynamic> map) {
    return KategoriDropdown(
      idKategori: map['id_kategori'] ?? 0,
      namaKategori: map['nama_kategori']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'KategoriDropdown{id: $idKategori, nama: $namaKategori}';
  }
}