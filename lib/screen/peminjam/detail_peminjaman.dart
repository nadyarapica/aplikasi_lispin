import 'package:flutter/material.dart';
import 'package:aplikasi_lispin/models/peminjaman_models.dart';

class DetailPeminjamanPage extends StatelessWidget {
  final PeminjamanModel peminjaman;

  const DetailPeminjamanPage({super.key, required this.peminjaman});

  Color getStatusColor() {
    switch (peminjaman.status.toLowerCase()) {
      case 'menunggu': return Colors.orange;
      case 'dipinjam': return Colors.green;
      case 'selesai': return Colors.teal;
      case 'ditolak': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Detail Peminjaman', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Peminjam: ${peminjaman.peminjam}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Alat: ${peminjaman.namaAlat}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Tanggal Pinjam: ${peminjaman.tanggalPinjam}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text('Tanggal Kembali: ${peminjaman.tanggalKembali}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(peminjaman.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            if (peminjaman.keterangan != null && peminjaman.keterangan!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Keterangan: ${peminjaman.keterangan}', style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ),
          ],
        ),
      ),
    );
  }
}
