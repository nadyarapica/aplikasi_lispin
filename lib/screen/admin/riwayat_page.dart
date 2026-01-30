import 'package:aplikasi_lispin/screen/admin/filter.dart';
import 'package:aplikasi_lispin/screen/admin/riwayat_card.dart';
import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== SIDEBAR =====
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // 🔑 INI YANG PALING PENTING
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // ✅ SIDEBAR MUNCUL
              },
            );
          },
        ),

        title: const Text(
          'Riwayat',
          style: TextStyle(color: Colors.black),
        ),
      ),

      // ===== BODY (TIDAK DIUBAH) =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'search',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // FILTER CHIP
            Row(
              children: const [
                FilterChipWidget(label: 'semua', active: true),
                SizedBox(width: 8),
                FilterChipWidget(label: 'peminjam', active: false),
                SizedBox(width: 8),
                FilterChipWidget(label: 'pengembalian', active: false),
              ],
            ),

            const SizedBox(height: 16),

            // LIST RIWAYAT
            const RiwayatCard(
              name: 'Rotul',
              status: 'peminjam',
              selected: false,
            ),
            const RiwayatCard(
              name: 'Nico',
              status: 'peminjam',
              selected: true,
            ),
            const RiwayatCard(
              name: 'Melati',
              status: 'pengembalian',
              selected: false,
            ),
          ],
        ),
      ),
    );
  }
}
