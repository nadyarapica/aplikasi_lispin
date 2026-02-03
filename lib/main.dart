import 'package:aplikasi_lispin/screen/admin/dasboard/admin_dasboard.dart';
import 'package:aplikasi_lispin/screen/admin/dasboard/peminjam_dasboard.dart';
import 'package:aplikasi_lispin/screen/admin/denda_page.dart';
import 'package:aplikasi_lispin/screen/auth/login.dart';
import 'package:aplikasi_lispin/screen/auth/splash_screen.dart';
import 'package:aplikasi_lispin/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  print(Supabase.instance.client);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}