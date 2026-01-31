import 'package:aplikasi_lispin/models/alat_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<AlatModel>> getAlat() async {
    try {
      final response = await _supabase
          .from('alat')
          .select('''
            id_alat,
            nama_alat,
            id_kategori,
            kondisi,
            stok,
            gambar_alat,
            kategori:id_kategori(nama_kategori)
          ''')
          .order('nama_alat', ascending: true);

      print('Response getAlat: $response');

      List<AlatModel> alatList = [];
      for (var item in response) {
        String? gambarUrl;
        if (item['gambar_alat'] != null && item['gambar_alat'].toString().isNotEmpty) {
          gambarUrl = _supabase.storage
              .from('alat-images')
              .getPublicUrl(item['gambar_alat'].toString());
        }

        alatList.add(AlatModel(
          idAlat: item['id_alat'] as int,
          namaAlat: item['nama_alat']?.toString() ?? '',
          idKategori: item['id_kategori'] as int?,
          namaKategori: item['kategori']?['nama_kategori']?.toString(),
          kondisi: item['kondisi']?.toString() ?? 'Baik',
          stok: item['stok'] as int? ?? 0,
          gambarAlat: item['gambar_alat']?.toString(),
          gambarUrl: gambarUrl,
        ));
      }

      print('Jumlah alat: ${alatList.length}');
      return alatList;
    } catch (e) {
      print('Error get alat: $e');
      throw Exception('Gagal mengambil data alat: $e');
    }
  }

  Future<List<KategoriDropdown>> getKategoriDropdown() async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('id_kategori, nama_kategori')
          .order('nama_kategori', ascending: true);

      print('Response getKategoriDropdown: $response');

      List<KategoriDropdown> kategoriList = [];
      for (var item in response) {
        kategoriList.add(KategoriDropdown(
          idKategori: item['id_kategori'] as int,
          namaKategori: item['nama_kategori']?.toString() ?? '',
        ));
      }

      return kategoriList;
    } catch (e) {
      print('Error get kategori dropdown: $e');
      throw Exception('Gagal mengambil data kategori: $e');
    }
  }

 Future<void> tambahAlat({
  required String namaAlat,
  int? idKategori,
  required String kondisi,
  required int stok,
  XFile? imageFile,
}) async {
  try {
    String? gambarPath;

    if (imageFile != null) {
      gambarPath = await _uploadImage(imageFile);
    }

    final response = await _supabase.from('alat').insert({
      'nama_alat': namaAlat,
      'id_kategori': idKategori,
      'kondisi': kondisi,
      'stok': stok,
      'gambar_alat': gambarPath,
    }).select();

    print('Response tambah alat: $response');

    if (response.isEmpty) {
      throw Exception('Gagal menambahkan alat');
    }
  } catch (e) {
    print('Error tambah alat: $e');
    throw Exception('Gagal menambahkan alat: $e');
  }
}

  Future<void> updateAlat({
    required int idAlat,
    required String namaAlat,
    int? idKategori,
    required String kondisi,
    required int stok,
    XFile? imageFile,
    bool deleteOldImage = false,
  }) async {
    try {
      String? gambarPath;

      final oldData = await _supabase
          .from('alat')
          .select('gambar_alat')
          .eq('id_alat', idAlat)
          .single();

      final oldGambarPath = oldData['gambar_alat']?.toString();

      if (imageFile != null) {
        if (oldGambarPath != null && oldGambarPath.isNotEmpty) {
          await _deleteImage(oldGambarPath);
        }
        gambarPath = await _uploadImage(imageFile);
      } else if (deleteOldImage && oldGambarPath != null) {
        await _deleteImage(oldGambarPath);
        gambarPath = null;
      } else {
        gambarPath = oldGambarPath;
      }

      final response = await _supabase
          .from('alat')
          .update({
            'nama_alat': namaAlat,
            'id_kategori': idKategori,
            'kondisi': kondisi,
            'stok': stok,
            'gambar_alat': gambarPath,
          })
          .eq('id_alat', idAlat)
          .select();

      print('Response update alat: $response');

      if (response.isEmpty) {
        throw Exception('Alat tidak ditemukan');
      }
    } catch (e) {
      print('Error update alat: $e');
      throw Exception('Gagal mengupdate alat: $e');
    }
  }

  Future<void> hapusAlat(int idAlat) async {
    try {
      print('Menghapus alat ID: $idAlat');

      final alatResponse = await _supabase
          .from('alat')
          .select('gambar_alat')
          .eq('id_alat', idAlat);

      if (alatResponse.isEmpty) {
        throw Exception('Alat tidak ditemukan');
      }

      final gambarPath = alatResponse[0]['gambar_alat']?.toString();
      print('Alat ditemukan dengan gambar: $gambarPath');

      final detailResponse = await _supabase
          .from('detail_peminjaman')
          .select('id_detail')
          .eq('id_alat', idAlat);

      print('Jumlah detail peminjaman terkait: ${detailResponse.length}');

      if (detailResponse.isNotEmpty) {
        throw Exception(
            'Tidak dapat menghapus alat karena masih ada ${detailResponse.length} peminjaman yang terkait');
      }

      if (gambarPath != null && gambarPath.isNotEmpty) {
        await _deleteImage(gambarPath);
      }

      final deleteResponse = await _supabase
          .from('alat')
          .delete()
          .eq('id_alat', idAlat)
          .select();

      print('Delete response: $deleteResponse');

      if (deleteResponse.isEmpty) {
        throw Exception('Gagal menghapus alat');
      }
    } catch (e) {
      print('Error hapus alat: $e');
      throw Exception(e.toString());
    }
  }

  Future<String> _uploadImage(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      
      String fileExt = 'jpg'; // default
      if (imageFile.name.isNotEmpty) {
        final nameParts = imageFile.name.split('.');
        if (nameParts.length > 1) {
          fileExt = nameParts.last.toLowerCase();
        }
      }
      
      if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExt)) {
        fileExt = 'jpg'; 
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'alat/$fileName';

      print('Uploading image: $filePath (extension: $fileExt)');

      await _supabase.storage.from('alat-images').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              contentType: 'image/$fileExt',
              upsert: false,
            ),
          );

      print('Image uploaded successfully: $filePath');
      return filePath;
    } catch (e) {
      print('Error upload image: $e');
      throw Exception('Gagal upload gambar: $e');
    }
  }

  Future<void> _deleteImage(String filePath) async {
    try {
      print('Deleting image: $filePath');
      await _supabase.storage.from('alat-images').remove([filePath]);
      print('Image deleted successfully');
    } catch (e) {
      print('Error delete image: $e');
      
    }
  }

  Future<List<AlatModel>> searchAlat(String keyword) async {
    try {
      final response = await _supabase
          .from('alat')
          .select('''
            id_alat,
            nama_alat,
            id_kategori,
            kondisi,
            stok,
            gambar_alat,
            kategori:id_kategori(nama_kategori)
          ''')
          .ilike('nama_alat', '%$keyword%')
          .order('nama_alat', ascending: true);

      List<AlatModel> alatList = [];
      for (var item in response) {
        String? gambarUrl;
        if (item['gambar_alat'] != null && item['gambar_alat'].toString().isNotEmpty) {
          gambarUrl = _supabase.storage
              .from('alat-images')
              .getPublicUrl(item['gambar_alat'].toString());
        }

        alatList.add(AlatModel(
          idAlat: item['id_alat'] as int,
          namaAlat: item['nama_alat']?.toString() ?? '',
          idKategori: item['id_kategori'] as int?,
          namaKategori: item['kategori']?['nama_kategori']?.toString(),
          kondisi: item['kondisi']?.toString() ?? 'Baik',
          stok: item['stok'] as int? ?? 0,
          gambarAlat: item['gambar_alat']?.toString(),
          gambarUrl: gambarUrl,
        ));
      }

      return alatList;
    } catch (e) {
      print('Error search alat: $e');
      throw Exception('Gagal mencari alat: $e');
    }
  }

  Future<AlatModel?> getAlatById(int idAlat) async {
    try {
      final response = await _supabase
          .from('alat')
          .select('''
            id_alat,
            nama_alat,
            id_kategori,
            kondisi,
            stok,
            gambar_alat,
            kategori:id_kategori(nama_kategori)
          ''')
          .eq('id_alat', idAlat)
          .single();

      String? gambarUrl;
      if (response['gambar_alat'] != null && response['gambar_alat'].toString().isNotEmpty) {
        gambarUrl = _supabase.storage
            .from('alat-images')
            .getPublicUrl(response['gambar_alat'].toString());
      }

      return AlatModel(
        idAlat: response['id_alat'] as int,
        namaAlat: response['nama_alat']?.toString() ?? '',
        idKategori: response['id_kategori'] as int?,
        namaKategori: response['kategori']?['nama_kategori']?.toString(),
        kondisi: response['kondisi']?.toString() ?? 'Baik',
        stok: response['stok'] as int? ?? 0,
        gambarAlat: response['gambar_alat']?.toString(),
        gambarUrl: gambarUrl,
      );
    } catch (e) {
      print('Error get alat by id: $e');
      return null;
    }
  }
}