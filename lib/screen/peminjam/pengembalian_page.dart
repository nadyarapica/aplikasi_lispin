import 'package:aplikasi_lispin/screen/peminjam/card_pengembalian.dart';
import 'package:flutter/material.dart';

class PengembalianpeminjamPage extends StatelessWidget {
  const PengembalianpeminjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          'pengembalian alat',
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
          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
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

          /// TITLE
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'daftar pengembalian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// LIST
         Expanded(
  child: ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    children: const [
      PengembalianPengembalianCard(
        nama: "Egi Dwi Saputri",
        tanggal: "23/01/2026",
        status: "Pengembalian",
      ),
      SizedBox(height: 12),
      PengembalianPengembalianCard(
        nama: "Melati Tiara",
        tanggal: "23/01/2026",
        status: "Selesai",
      ),
    ],
  ),
),
        ],
      ),
    );
  }
}

