import 'package:aplikasi_lispin/models/kategori_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// =====================
  /// GET ALL KATEGORI dengan jumlah alat
  /// =====================
  Future<List<KategoriModel>> getKategori() async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('''
            id_kategori,
            nama_kategori,
            deskripsi,
            alat:alat(id_alat)  # Ambil ID alat untuk count
          ''')
          .order('nama_kategori', ascending: true);

      print('Response dari Supabase: $response'); // Debug log

      List<KategoriModel> kategoriList = [];
      for (var item in response) {
        final alatList = item['alat'] as List;
        final jumlahAlat = alatList.length;
        
        kategoriList.add(KategoriModel(
          idKategori: item['id_kategori'] as int, // Pastikan tipe data int
          namaKategori: item['nama_kategori']?.toString() ?? '',
          deskripsi: item['deskripsi']?.toString() ?? '',
          jumlahAlat: jumlahAlat,
        ));
      }
      
      print('Jumlah kategori: ${kategoriList.length}'); // Debug log
      return kategoriList;
    } catch (e) {
      print('Error get kategori: $e');
      throw Exception('Gagal mengambil data kategori: $e');
    }
  }

  /// =====================
  /// SEARCH KATEGORI
  /// =====================
  Future<List<KategoriModel>> searchKategori(String keyword) async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('''
            id_kategori,
            nama_kategori,
            deskripsi,
            alat:alat(id_alat)
          ''')
          .ilike('nama_kategori', '%$keyword%')
          .order('nama_kategori', ascending: true);

      List<KategoriModel> kategoriList = [];
      for (var item in response) {
        final alatList = item['alat'] as List;
        final jumlahAlat = alatList.length;
        
        kategoriList.add(KategoriModel(
          idKategori: item['id_kategori'] as int,
          namaKategori: item['nama_kategori']?.toString() ?? '',
          deskripsi: item['deskripsi']?.toString() ?? '',
          jumlahAlat: jumlahAlat,
        ));
      }
      return kategoriList;
    } catch (e) {
      print('Error search kategori: $e');
      throw Exception('Gagal mencari kategori: $e');
    }
  }

  /// =====================
  /// TAMBAH KATEGORI
  /// =====================
  Future<Map<String, dynamic>> tambahKategori({
    required String namaKategori,
    required String deskripsi,
  }) async {
    try {
      final response = await _supabase
          .from('kategori')
          .insert({
            'nama_kategori': namaKategori,
            'deskripsi': deskripsi,
          })
          .select() // Ambil data yang baru saja diinsert
          .single(); // Hanya ambil satu row

      print('Response tambah: $response'); // Debug log
      
      return {
        'success': true,
        'data': response,
        'id_kategori': response['id_kategori'] as int,
      };
    } catch (e) {
      print('Error tambah kategori: $e');
      throw Exception('Gagal menambahkan kategori: $e');
    }
  }

  /// =====================
  /// UPDATE KATEGORI
  /// =====================
  Future<void> updateKategori({
    required int idKategori,
    required String namaKategori,
    required String deskripsi,
  }) async {
    try {
      print('Updating kategori ID: $idKategori'); // Debug log
      
      final response = await _supabase
          .from('kategori')
          .update({
            'nama_kategori': namaKategori,
            'deskripsi': deskripsi,
          })
          .eq('id_kategori', idKategori)
          .select();

      print('Update response: $response'); // Debug log
      
      if (response.isEmpty) {
        throw Exception('Kategori tidak ditemukan');
      }
    } catch (e) {
      print('Error update kategori: $e');
      throw Exception('Gagal mengupdate kategori: $e');
    }
  }

  /// =====================
  /// DELETE KATEGORI
  /// =====================
  Future<void> hapusKategori(int idKategori) async {
    try {
      print('Menghapus kategori ID: $idKategori'); // Debug log
      
      // 1. Cek apakah kategori ada
      final kategoriResponse = await _supabase
          .from('kategori')
          .select()
          .eq('id_kategori', idKategori);

      if (kategoriResponse.isEmpty) {
        throw Exception('Kategori tidak ditemukan');
      }

      print('Kategori ditemukan: ${kategoriResponse[0]}'); // Debug log

      // 2. Cek apakah ada alat yang menggunakan kategori ini
      final alatResponse = await _supabase
          .from('alat')
          .select('id_alat')
          .eq('id_kategori', idKategori);

      print('Jumlah alat terkait: ${alatResponse.length}'); // Debug log

      if (alatResponse.isNotEmpty) {
        throw Exception('Tidak dapat menghapus kategori karena masih ada ${alatResponse.length} alat yang terkait');
      }

      // 3. Hapus kategori
      final deleteResponse = await _supabase
          .from('kategori')
          .delete()
          .eq('id_kategori', idKategori)
          .select();

      print('Delete response: $deleteResponse'); // Debug log
      
      if (deleteResponse.isEmpty) {
        throw Exception('Gagal menghapus kategori');
      }
    } catch (e) {
      print('Error hapus kategori: $e');
      throw Exception(e.toString());
    }
  }

  /// =====================
  /// GET KATEGORI BY ID
  /// =====================
  Future<KategoriModel?> getKategoriById(int idKategori) async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('''
            id_kategori,
            nama_kategori,
            deskripsi,
            alat:alat(id_alat)
          ''')
          .eq('id_kategori', idKategori)
          .single();

      if (response != null) {
        final alatList = response['alat'] as List;
        final jumlahAlat = alatList.length;
        
        return KategoriModel(
          idKategori: response['id_kategori'] as int,
          namaKategori: response['nama_kategori']?.toString() ?? '',
          deskripsi: response['deskripsi']?.toString() ?? '',
          jumlahAlat: jumlahAlat,
        );
      }
      return null;
    } catch (e) {
      print('Error get kategori by id: $e');
      return null;
    }
  }
}