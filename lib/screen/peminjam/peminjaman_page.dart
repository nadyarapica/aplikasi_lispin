import 'package:aplikasi_lispin/screen/peminjam/alat_peminjam_page.dart';
import 'package:aplikasi_lispin/screen/peminjam/card_peminjaman.dart';
import 'package:flutter/material.dart';

class PeminjamanPeminjamPage extends StatelessWidget {
  const PeminjamanPeminjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Peminjam',
          style: TextStyle(color: Colors.black),
        ),
        leading: const Icon(Icons.menu, color: Colors.black),
      ),

      body: Column(
        children: [
          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          /// LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                PeminjamanPeminjamCard(
                  nama: 'Egi dwi saputri',
                  tanggal: '20/01/2026',
                  status: 'Menunggu',
                ),
                PeminjamanPeminjamCard(
                  nama: 'Egi dwi saputri',
                  tanggal: '20/01/2026',
                  status: 'Dipinjam',
                ),
                PeminjamanPeminjamCard(
                  nama: 'Egi dwi saputri',
                  tanggal: '20/01/2026',
                  status: 'Selesai',
                ),
                PeminjamanPeminjamCard(
                  nama: 'Egi dwi saputri',
                  tanggal: '20/01/2026',
                  status: 'Ditolak',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
