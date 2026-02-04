import 'package:aplikasi_lispin/screen/peminjam/card_peminjaman.dart';
import 'package:aplikasi_lispin/screen/peminjam/detail_peminjaman.dart';
import 'package:flutter/material.dart';
import 'peminjaman_manager.dart';
import '../admin/widgets/sidebar.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({Key? key}) : super(key: key);

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dipinjam': return Colors.green;
      case 'ditolak': return Colors.red;
      case 'menunggu': return Colors.orange;
      case 'selesai': return Colors.teal;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = PeminjamanManager.items;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomSidebar(role: UserRole.peminjam),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Peminjaman', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Daftar Peminjaman', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Belum ada peminjaman'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final e = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PeminjamanCard(
                          nama: e.namaAlat,
                          tanggal: e.tanggalKembali,
                          status: e.status,
                          statusColor: _statusColor(e.status),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPeminjamanPage(peminjaman: e),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
