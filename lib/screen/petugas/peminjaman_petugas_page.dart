import 'package:flutter/material.dart';
import 'card_peminjaman_petugas.dart';
import 'package:aplikasi_lispin/screen/peminjam/peminjaman_manager.dart';

class PeminjamanPetugasPage extends StatefulWidget {
  const PeminjamanPetugasPage({Key? key}) : super(key: key);

  @override
  State<PeminjamanPetugasPage> createState() =>
      _PeminjamanPetugasPageState();
}

class _PeminjamanPetugasPageState extends State<PeminjamanPetugasPage> {

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dipinjam':
        return const Color(0xFF4CAF50);
      case 'ditolak':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFFFFEB3B); // pengajuan
    }
  }

  @override
  Widget build(BuildContext context) {

    final items = PeminjamanManager.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'peminjaman',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'search',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'daftar peminjaman',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {

                final e = items[index];

                return Column(
                  children: [
                    PeminjamanCard(
                      nama: e.nama,
                      tanggal: e.tanggal,
                      status: e.status,
                      statusColor: _statusColor(e.status),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
