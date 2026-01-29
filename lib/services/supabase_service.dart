import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://pdpzxbobqkqxlmsgoken.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBkcHp4Ym9icWtxeGxtc2dva2VuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMzM5NjAsImV4cCI6MjA4MzkwOTk2MH0.EaqOp59V0kqBn1q3Eg1aTV84yLmuurQQP3zZEB_TmMk';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
