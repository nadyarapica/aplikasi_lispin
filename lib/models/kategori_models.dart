// models/kategori_model.dart
class KategoriModel {
  final int idKategori;
  final String namaKategori;
  final String deskripsi;
  final int jumlahAlat;

  KategoriModel({
    required this.idKategori,
    required this.namaKategori,
    required this.deskripsi,
    this.jumlahAlat = 0,
  });

  factory KategoriModel.fromMap(Map<String, dynamic> map) {
    print('Membuat KategoriModel dari map: $map'); // Debug log
    
    final id = map['id_kategori'];
    
    // Handle berbagai tipe data untuk id_kategori
    int parsedId;
    if (id is int) {
      parsedId = id;
    } else if (id is String) {
      parsedId = int.tryParse(id) ?? 0;
    } else if (id is double) {
      parsedId = id.toInt();
    } else {
      parsedId = 0;
    }
    
    return KategoriModel(
      idKategori: parsedId,
      namaKategori: map['nama_kategori']?.toString() ?? '',
      deskripsi: map['deskripsi']?.toString() ?? '',
      jumlahAlat: (map['alat'] is List) ? (map['alat'] as List).length : 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_kategori': idKategori,
      'nama_kategori': namaKategori,
      'deskripsi': deskripsi,
      'jumlah_alat': jumlahAlat,
    };
  }

  @override
  String toString() {
    return 'KategoriModel{id: $idKategori, nama: $namaKategori, alat: $jumlahAlat}';
  }
}