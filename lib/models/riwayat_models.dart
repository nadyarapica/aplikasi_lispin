class RiwayatModel {
  final int idDetail;
  final int idPeminjaman;
  final String namaUser;
  final String status;

  RiwayatModel({
    required this.idDetail,
    required this.idPeminjaman,
    required this.namaUser,
    required this.status,
  });

  factory RiwayatModel.fromMap(Map<String, dynamic> map) {
    return RiwayatModel(
      idDetail: map['id_detail'],
      idPeminjaman: map['peminjaman']['id_peminjaman'],
      status: map['peminjaman']['status'] ?? '',
      namaUser: map['peminjaman']['users']['nama'] ?? '',
    );
  }
}
