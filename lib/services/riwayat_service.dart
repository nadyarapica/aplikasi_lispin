import 'package:aplikasi_lispin/models/riwayat_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatService {
  final SupabaseClient _client = Supabase.instance.client;

  // ambil riwayat dari detail_peminjaman -> peminjaman -> users
  Future<List<RiwayatModel>> fetchRiwayat() async {
    final data = await _client
        .from('detail_peminjaman')
        .select('''
          id_detail,
          peminjaman (
            id_peminjaman,
            status,
            users (
              nama
            )
          )
        ''')
        .order('id_detail', ascending: false);

    return (data as List)
        .map((e) => RiwayatModel.fromMap(e))
        .toList();
  }

  // update status di tabel peminjaman
  Future<void> updateStatusPeminjaman({
    required int idPeminjaman,
    required String status,
  }) async {
    final res = await _client
        .from('peminjaman')
        .update({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id_peminjaman', idPeminjaman)
        .select();

    if (res.isEmpty) {
      throw Exception('Update gagal');
    }
  }

  // hapus dari detail_peminjaman
  Future<void> deleteDetail(int idDetail) async {
    await _client
        .from('detail_peminjaman')
        .delete()
        .eq('id_detail', idDetail);
  }
}
