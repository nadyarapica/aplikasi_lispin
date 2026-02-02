import 'package:aplikasi_lispin/models/denda_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DendaService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<DendaModel>> getDenda() async {
    final data = await _client.from('denda').select().order('id');
    return (data as List)
        .map((e) => DendaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> tambahDenda(DendaModel denda) async {
    await _client.from('denda').insert({
      'nama': denda.nama,
      'biaya': denda.biaya,
    });
  }

  Future<void> editDenda(int id, DendaModel denda) async {
    await _client.from('denda').update({
      'nama': denda.nama,
      'biaya': denda.biaya,
    }).eq('id', id);
  }

  Future<void> hapusDenda(int id) async {
    await _client.from('denda').delete().eq('id', id);
  }
}
