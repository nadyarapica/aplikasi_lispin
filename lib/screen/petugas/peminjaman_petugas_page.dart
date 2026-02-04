import 'package:aplikasi_lispin/screen/peminjam/peminjaman_manager.dart';
import 'package:flutter/material.dart';
import 'card_peminjaman_petugas.dart';
import '../admin/widgets/sidebar.dart';

class PeminjamanPetugasPage extends StatefulWidget {
  const PeminjamanPetugasPage({Key? key}) : super(key: key);

  @override
  State<PeminjamanPetugasPage> createState() => _PeminjamanPetugasPageState();
}

class _PeminjamanPetugasPageState extends State<PeminjamanPetugasPage> {
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dipinjam':
        return const Color(0xFF4CAF50);
      case 'ditolak':
        return const Color(0xFFF44336);
      case 'menunggu':
        return const Color(0xFFFFEB3B);
      default:
        return Colors.grey;
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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CustomSidebar(role: UserRole.petugas),
            );
          },
        ),
        title: const Text(
          'Peminjaman',
          style: TextStyle(color: Colors.black, fontSize: 18),
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
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Daftar Peminjaman',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                      nama: e.namaAlat,
                      tanggal: e.tanggalKembali,
                      status: e.status,
                      statusColor: _statusColor(e.status),
                      onTapApprove: () {
                        setState(() {
                          PeminjamanManager.approve(e);
                        });
                      },
                      onTapReject: () {
                        setState(() {
                          PeminjamanManager.reject(e);
                        });
                      },
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
