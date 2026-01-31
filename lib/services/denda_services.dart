import 'package:aplikasi_lispin/models/denda_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DendaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all denda
  Future<List<DendaModel>> getAllDenda() async {
    try {
      final response = await _supabase
          .from('denda')
          .select('*')
          .order('id_denda', ascending: true);
      
      return (response as List)
          .map((json) => DendaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting denda: $e');
      rethrow;
    }
  }

  // Get denda by ID
  Future<DendaModel?> getDendaById(int idDenda) async {
    try {
      final response = await _supabase
          .from('denda')
          .select('*')
          .eq('id_denda', idDenda)
          .single();
      
      return DendaModel.fromJson(response);
    } catch (e) {
      print('Error getting denda by id: $e');
      return null;
    }
  }

  // Get denda by pengembalian ID
  Future<DendaModel?> getDendaByPengembalianId(int idPengembalian) async {
    try {
      final response = await _supabase
          .from('denda')
          .select('*')
          .eq('id_pengembalian', idPengembalian)
          .single();
      
      return DendaModel.fromJson(response);
    } catch (e) {
      print('Error getting denda by pengembalian id: $e');
      return null;
    }
  }

  // Get denda with pengembalian details
  Future<List<Map<String, dynamic>>> getDendaWithDetails() async {
    try {
      final response = await _supabase
          .from('denda')
          .select('*, pengembalian(*, peminjaman(*, users(*)))')
          .order('id_denda', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting denda with details: $e');
      rethrow;
    }
  }

  // Add new denda
  Future<int?> addDenda(DendaModel denda) async {
    try {
      final response = await _supabase
          .from('denda')
          .insert(denda.toJsonForInsert())
          .select('id_denda')
          .single();
      
      return response['id_denda'] as int?;
    } catch (e) {
      print('Error adding denda: $e');
      rethrow;
    }
  }

  // Update denda
  Future<void> updateDenda(int idDenda, DendaModel denda) async {
    try {
      await _supabase
          .from('denda')
          .update(denda.toJsonForInsert())
          .eq('id_denda', idDenda);
    } catch (e) {
      print('Error updating denda: $e');
      rethrow;
    }
  }

  // Delete denda
  Future<void> deleteDenda(int idDenda) async {
    try {
      await _supabase.from('denda').delete().eq('id_denda', idDenda);
    } catch (e) {
      print('Error deleting denda: $e');
      rethrow;
    }
  }

  // Search denda by hari terlambat or total denda
  Future<List<DendaModel>> searchDenda(String query) async {
    try {
      final parsedQuery = int.tryParse(query);
      if (parsedQuery == null) {
        return [];
      }

      final response = await _supabase
          .from('denda')
          .select('*')
          .or('hari_terlambat.eq.$parsedQuery,total_denda.eq.$parsedQuery');
      
      return (response as List)
          .map((json) => DendaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching denda: $e');
      return [];
    }
  }

  // Get total denda amount
  Future<int> getTotalDendaAmount() async {
    try {
      final response = await _supabase
          .from('denda')
          .select('total_denda');
      
      int total = 0;
      for (var item in response as List) {
        total += (item['total_denda'] as int?) ?? 0;
      }
      
      return total;
    } catch (e) {
      print('Error getting total denda amount: $e');
      return 0;
    }
  }

  // Get denda by date range
  Future<List<Map<String, dynamic>>> getDendaByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase
          .from('denda')
          .select('*, pengembalian!inner(tanggal_kembali)')
          .gte('pengembalian.tanggal_kembali', startDate.toIso8601String().split('T')[0])
          .lte('pengembalian.tanggal_kembali', endDate.toIso8601String().split('T')[0])
          .order('id_denda', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting denda by date range: $e');
      return [];
    }
  }

  // Calculate denda
  int calculateDenda({
    required int hariTerlambat,
    required int dendaPerHari,
  }) {
    return hariTerlambat * dendaPerHari;
  }

  // Get statistics
  Future<Map<String, dynamic>> getDendaStatistics() async {
    try {
      final allDenda = await getAllDenda();
      
      int totalDenda = 0;
      int totalHariTerlambat = 0;
      int jumlahDenda = allDenda.length;
      
      for (var denda in allDenda) {
        totalDenda += denda.totalDenda;
        totalHariTerlambat += denda.hariTerlambat;
      }
      
      double avgDenda = jumlahDenda > 0 ? totalDenda / jumlahDenda : 0;
      double avgHariTerlambat = jumlahDenda > 0 ? totalHariTerlambat / jumlahDenda : 0;
      
      return {
        'total_denda': totalDenda,
        'jumlah_kasus': jumlahDenda,
        'rata_rata_denda': avgDenda,
        'rata_rata_hari_terlambat': avgHariTerlambat,
        'total_hari_terlambat': totalHariTerlambat,
      };
    } catch (e) {
      print('Error getting denda statistics: $e');
      return {
        'total_denda': 0,
        'jumlah_kasus': 0,
        'rata_rata_denda': 0.0,
        'rata_rata_hari_terlambat': 0.0,
        'total_hari_terlambat': 0,
      };
    }
  }
}