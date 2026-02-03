import 'package:aplikasi_lispin/screen/peminjam/card_peminjaman.dart';
import 'package:aplikasi_lispin/screen/peminjam/peminjaman_manager.dart';
import 'package:flutter/material.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {

    final items = PeminjamanManager.items;

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

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ...items.map((item) {
                  return PeminjamanPeminjamCard(
                    nama: item.nama,
                    tanggal: item.tanggal,
                    status: item.status,
                  );
                }),

                // dummy lama kamu (tidak dihapus)
                const PeminjamanPeminjamCard(
                  nama: 'Egi dwi saputri',
                  tanggal: '20/01/2026',
                  status: 'Menunggu',
                ),
                const PeminjamanPeminjamCard(
                  nama: 'Egi dwi saputri',
                  tanggal: '20/01/2026',
                  status: 'Dipinjam',
                ),
                const PeminjamanPeminjamCard(
                  nama: 'Egi dwi saputri',
                  tanggal: '20/01/2026',
                  status: 'Selesai',
                ),
                const PeminjamanPeminjamCard(
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
