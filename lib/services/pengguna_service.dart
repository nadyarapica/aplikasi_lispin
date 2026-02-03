// services/pengguna_service.dart
import 'package:aplikasi_lispin/models/pengguna_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenggunaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ─── READ (semua) ────────────────────────────────────────────────
  Future<List<PenggunaModel>> getPengguna() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .order('nama', ascending: true);

      return response.map((item) => PenggunaModel.fromMap(item)).toList();
    } catch (e) {
      print('Error get pengguna: $e');
      throw Exception('Gagal mengambil data pengguna');
    }
  }

  // ─── READ (pencarian) ────────────────────────────────────────────
  Future<List<PenggunaModel>> searchPengguna(String keyword) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .or('nama.ilike.%$keyword%,username.ilike.%$keyword%')
          .order('nama', ascending: true);

      return response.map((item) => PenggunaModel.fromMap(item)).toList();
    } catch (e) {
      print('Error search pengguna: $e');
      throw Exception('Gagal mencari pengguna');
    }
  }

  // ─── CREATE ──────────────────────────────────────────────────────
  Future<void> tambahPengguna({
    required String nama,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      // 1. Buat akun di Supabase Auth
      final authResponse = await _supabase.auth.signUp(
        email: username,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Gagal membuat akun auth');
      }

      final String userId = authResponse.user!.id;

      // 2. Simpan ke tabel users
      //    role disimpan lowercase agar sesuai CHECK constraint di DB:
      //    role = ANY (ARRAY['admin','petugas','peminjam'])
      await _supabase.from('users').insert({
        'id_user': userId,
        'nama': nama,
        'username': username,
        'password': password,
        'role': role.toLowerCase(), // ← penting: lowercase
      });
    } catch (e) {
      print('Error tambah pengguna: $e');
      throw Exception('Gagal menambahkan pengguna: ${e.toString()}');
    }
  }

  // ─── UPDATE ──────────────────────────────────────────────────────
  Future<void> updatePengguna({
    required String idUser,
    required String nama,
    required String username,
    required String role,
  }) async {
    try {
      await _supabase.from('users').update({
        'nama': nama,
        'username': username,
        'role': role.toLowerCase(), // ← penting: lowercase
      }).eq('id_user', idUser);
    } catch (e) {
      print('Error update pengguna: $e');
      throw Exception('Gagal mengupdate pengguna');
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────
  Future<void> hapusPengguna(String idUser) async {
    try {
      // Hapus dari tabel users dulu
      await _supabase.from('users').delete().eq('id_user', idUser);

      // Hapus dari Auth (optional — jalankan dari Admin API jika diperlukan)
      // Supabase client biasa tidak bisa menghapus user auth orang lain,
      // butuh service-role key. Biarkan di sini sebagai placeholder.
      // await _supabase.auth.admin.deleteUser(idUser);
    } catch (e) {
      print('Error hapus pengguna: $e');
      throw Exception('Gagal menghapus pengguna');
    }
  }
}