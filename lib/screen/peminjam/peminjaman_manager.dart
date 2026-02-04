import 'package:aplikasi_lispin/models/peminjaman_models.dart';


class PeminjamanManager {
  static final List<PeminjamanModel> items = [];

  static void tambah(PeminjamanModel data) {
    items.add(data);
  }

  static void hapus(PeminjamanModel data) {
    items.remove(data);
  }

  static void updateStatus(PeminjamanModel data, String status, {String? keterangan}) {
    data.status = status;
    if (keterangan != null) {
      data.keterangan = keterangan;
    }
  }

  // ✅ Tambahkan ini
  static void approve(PeminjamanModel data) {
    updateStatus(data, 'dipinjam');
  }

  static void reject(PeminjamanModel data, {String? keterangan}) {
    updateStatus(data, 'ditolak', keterangan: keterangan);
  }
}
