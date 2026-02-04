class PeminjamanModel {
  final String peminjam;
  final String namaAlat;
  final String tanggalPinjam;
  final String tanggalKembali;
  String status;
  String? keterangan;

  PeminjamanModel({
    required this.peminjam,
    required this.namaAlat,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.status,
    this.keterangan,
  });
}
