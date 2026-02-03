// services/denda_service.dart
import 'package:aplikasi_lispin/models/denda_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DendaService {
  final SupabaseClient _client = Supabase.instance.client;

  // ─── Fetch semua pengembalian yang ada di DB ─────────────────────
  //     Dipakai untuk Dropdown di dialog tambah/edit denda
  Future<List<Map<String, dynamic>>> getPengembalianList() async {
    try {
      final data = await _client
          .from('pengembalian')
          .select('id_pengembalian, id_peminjaman, tanggal_kembali')
          .order('id_pengembalian', ascending: false);
      return data;
    } catch (e) {
      print('Error get pengembalian list: $e');
      throw Exception('Gagal mengambil data pengembalian');
    }
  }

  // ─── READ (semua denda) ──────────────────────────────────────────
  Future<List<DendaModel>> getDenda() async {
    try {
      final List<Map<String, dynamic>> data = await _client
          .from('denda')
          .select()
          .order('id_denda', ascending: false);
      return data.map((e) => DendaModel.fromJson(e)).toList();
    } catch (e) {
      print('Error get denda: $e');
      throw Exception('Gagal mengambil data denda');
    }
  }

  // ─── READ (by id) ────────────────────────────────────────────────
  Future<DendaModel?> getDendaById(int id) async {
    try {
      final data = await _client
          .from('denda')
          .select()
          .eq('id_denda', id)
          .maybeSingle();
      if (data == null) return null;
      return DendaModel.fromJson(data);
    } catch (e) {
      print('Error get denda by id: $e');
      return null;
    }
  }

  // ─── CREATE ──────────────────────────────────────────────────────
  Future<void> tambahDenda(DendaModel denda) async {
    try {
      await _client.from('denda').insert(denda.toInsertJson());
    } catch (e) {
      print('Error tambah denda: $e');
      throw Exception('Gagal menambahkan denda: ${e.toString()}');
    }
  }

  // ─── UPDATE ──────────────────────────────────────────────────────
  Future<void> editDenda(int id, DendaModel denda) async {
    try {
      await _client
          .from('denda')
          .update(denda.toUpdateJson())
          .eq('id_denda', id);
    } catch (e) {
      print('Error edit denda: $e');
      throw Exception('Gagal mengupdate denda: ${e.toString()}');
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────
  Future<void> hapusDenda(int id) async {
    try {
      await _client.from('denda').delete().eq('id_denda', id);
    } catch (e) {
      print('Error hapus denda: $e');
      throw Exception('Gagal menghapus denda');
    }
  }

  // ─── HELPER ──────────────────────────────────────────────────────
  int hitungTotalDenda(int hariTerlambat, int dendaPerHari) {
    return hariTerlambat * dendaPerHari;
  }
}