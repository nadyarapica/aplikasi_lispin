import 'package:aplikasi_lispin/models/denda_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DendaService {
  final SupabaseClient _client = Supabase.instance.client;

  // Get all denda with pengembalian info
  Future<List<DendaModel>> getDenda() async {
    try {
      final data = await _client
          .from('denda')
          .select()
          .order('id_denda', ascending: false);
      
      return (data as List)
          .map((e) => DendaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error get denda: $e');
      throw Exception('Gagal mengambil data denda');
    }
  }

  // Get denda by ID
  Future<DendaModel?> getDendaById(int id) async {
    try {
      final data = await _client
          .from('denda')
          .select()
          .eq('id_denda', id)
          .single();
      
      return DendaModel.fromJson(data);
    } catch (e) {
      print('Error get denda by id: $e');
      return null;
    }
  }

  // Get denda by id_pengembalian
  Future<DendaModel?> getDendaByPengembalian(int idPengembalian) async {
    try {
      final data = await _client
          .from('denda')
          .select()
          .eq('id_pengembalian', idPengembalian)
          .maybeSingle();
      
      if (data == null) return null;
      return DendaModel.fromJson(data);
    } catch (e) {
      print('Error get denda by pengembalian: $e');
      return null;
    }
  }

  // Tambah denda
  Future<void> tambahDenda(DendaModel denda) async {
    try {
      await _client.from('denda').insert(denda.toInsertJson());
    } catch (e) {
      print('Error tambah denda: $e');
      throw Exception('Gagal menambahkan denda: ${e.toString()}');
    }
  }

  // Edit denda
  Future<void> editDenda(int id, DendaModel denda) async {
    try {
      await _client.from('denda').update({
        'id_pengembalian': denda.idPengembalian,
        'hari_terlambat': denda.hariTerlambat,
        'denda_per_hari': denda.dendaPerHari,
        'total_denda': denda.totalDenda,
      }).eq('id_denda', id);
    } catch (e) {
      print('Error edit denda: $e');
      throw Exception('Gagal mengupdate denda');
    }
  }

  // Hapus denda
  Future<void> hapusDenda(int id) async {
    try {
      await _client.from('denda').delete().eq('id_denda', id);
    } catch (e) {
      print('Error hapus denda: $e');
      throw Exception('Gagal menghapus denda');
    }
  }

  // Hitung total denda
  int hitungTotalDenda(int hariTerlambat, int dendaPerHari) {
    return hariTerlambat * dendaPerHari;
  }
}