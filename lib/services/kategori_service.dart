import 'package:aplikasi_lispin/models/kategori_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  final SupabaseClient _supabase = Supabase.instance.client;

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
          idKategori: item['id_kategori'] as int, 
          namaKategori: item['nama_kategori']?.toString() ?? '',
          deskripsi: item['deskripsi']?.toString() ?? '',
          jumlahAlat: jumlahAlat,
        ));
      }
      
      print('Jumlah kategori: ${kategoriList.length}'); 
      return kategoriList;
    } catch (e) {
      print('Error get kategori: $e');
      throw Exception('Gagal mengambil data kategori: $e');
    }
  }

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
          .select() 
          .single(); 

      print('Response tambah: $response');
      
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

      print('Update response: $response'); 
      
      if (response.isEmpty) {
        throw Exception('Kategori tidak ditemukan');
      }
    } catch (e) {
      print('Error update kategori: $e');
      throw Exception('Gagal mengupdate kategori: $e');
    }
  }

  Future<void> hapusKategori(int idKategori) async {
    try {
      print('Menghapus kategori ID: $idKategori'); 
      final kategoriResponse = await _supabase
          .from('kategori')
          .select()
          .eq('id_kategori', idKategori);

      if (kategoriResponse.isEmpty) {
        throw Exception('Kategori tidak ditemukan');
      }

      print('Kategori ditemukan: ${kategoriResponse[0]}'); 

      final alatResponse = await _supabase
          .from('alat')
          .select('id_alat')
          .eq('id_kategori', idKategori);

      print('Jumlah alat terkait: ${alatResponse.length}'); 

      if (alatResponse.isNotEmpty) {
        throw Exception('Tidak dapat menghapus kategori karena masih ada ${alatResponse.length} alat yang terkait');
      }

      final deleteResponse = await _supabase
          .from('kategori')
          .delete()
          .eq('id_kategori', idKategori)
          .select();

      print('Delete response: $deleteResponse'); 
      if (deleteResponse.isEmpty) {
        throw Exception('Gagal menghapus kategori');
      }
    } catch (e) {
      print('Error hapus kategori: $e');
      throw Exception(e.toString());
    }
  }

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