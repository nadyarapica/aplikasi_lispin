// services/pengguna_service.dart
import 'package:aplikasi_lispin/models/pengguna_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenggunaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// =====================
  /// GET ALL USERS
  /// =====================
  Future<List<PenggunaModel>> getPengguna() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .order('nama', ascending: true);

      List<PenggunaModel> users = [];
      for (var item in response) {
        users.add(PenggunaModel.fromMap(item));
      }
      return users;
    } catch (e) {
      print('Error get pengguna: $e');
      throw Exception('Gagal mengambil data pengguna');
    }
  }

  /// =====================
  /// SEARCH USERS
  /// =====================
  Future<List<PenggunaModel>> searchPengguna(String keyword) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .or('nama.ilike.%$keyword%,username.ilike.%$keyword%')
          .order('nama', ascending: true);

      List<PenggunaModel> users = [];
      for (var item in response) {
        users.add(PenggunaModel.fromMap(item));
      }
      return users;
    } catch (e) {
      print('Error search pengguna: $e');
      throw Exception('Gagal mencari pengguna');
    }
  }

  /// =====================
  /// TAMBAH USER
  /// =====================
  Future<void> tambahPengguna({
    required String nama,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      // 1️⃣ BUAT USER AUTH
      final authResponse = await _supabase.auth.signUp(
        email: username,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Gagal membuat akun auth');
      }

      final String userId = authResponse.user!.id;

      // 2️⃣ INSERT KE TABLE public.users
      await _supabase.from('users').insert({
        'id_user': userId,
        'nama': nama,
        'username': username,
        'password': password,
        'role': role,
      });
    } catch (e) {
      print('Error tambah pengguna: $e');
      throw Exception('Gagal menambahkan pengguna: ${e.toString()}');
    }
  }

  /// =====================
  /// UPDATE USER
  /// =====================
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
        'role': role,
      }).eq('id_user', idUser);
    } catch (e) {
      print('Error update pengguna: $e');
      throw Exception('Gagal mengupdate pengguna');
    }
  }

  /// =====================
  /// DELETE USER
  /// =====================
  Future<void> hapusPengguna(String idUser) async {
    try {
      await _supabase.from('users').delete().eq('id_user', idUser);
    } catch (e) {
      print('Error hapus pengguna: $e');
      throw Exception('Gagal menghapus pengguna');
    }
  }
}