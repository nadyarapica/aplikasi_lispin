import 'package:flutter/material.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          'Laporan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // BODY
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          LaporanCard(
            nama: 'Egi dwi saputri',
          ),
          SizedBox(height: 16),
          LaporanCard(
            nama: 'Melati Tiara Permata',
          ),
        ],
      ),
    );
  }
}

// ================= CARD LAPORAN =================
class LaporanCard extends StatelessWidget {
  final String nama;

  const LaporanCard({
    super.key,
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NAMA
          Text(
            nama,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          // TANGGAL
          _rowText('Mulai', '23/01/2026'),
          const SizedBox(height: 6),
          _rowText('Kembali', '28/01/2026'),

          const SizedBox(height: 12),
          const Divider(),

          // BARANG
          _rowText('multimeter', '1'),
          const SizedBox(height: 6),
          _rowText('helm sefty', '1'),

          const SizedBox(height: 16),

          // BUTTON PRINT
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.print, size: 18),
              label: const Text('Print Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowText(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: const TextStyle(fontSize: 13),
        ),
        Text(
          right,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
