import 'package:aplikasi_lispin/screen/admin/alat_page.dart';
import 'package:aplikasi_lispin/screen/auth/splash_screen.dart';
import 'package:aplikasi_lispin/screen/peminjam/alat_peminjam_page.dart';
import 'package:aplikasi_lispin/screen/peminjam/peminjaman_page.dart';
import 'package:aplikasi_lispin/screen/peminjam/pengembalian_page.dart';
import 'package:aplikasi_lispin/screen/petugas/laporan_petugas.dart';
import 'package:aplikasi_lispin/screen/petugas/peminjaman_petugas_page.dart';
import 'package:aplikasi_lispin/screen/petugas/pengembalian_petugas_page.dart';
import 'package:aplikasi_lispin/services/supabase_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PengembalianpeminjamPage(),
    );
  }
}