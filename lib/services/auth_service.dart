import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return 'Login gagal';
      }

      return null; // sukses
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Terjadi kesalahan';
    }
  }
}
