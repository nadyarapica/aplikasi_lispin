import 'package:aplikasi_lispin/screen/admin/denda_card.dart';
import 'package:aplikasi_lispin/screen/admin/tambah_denda_dialog.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class DendaPage extends StatelessWidget {
  const DendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomSidebar(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          'Denda',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'search',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    showDendaDialog(
                      context: context,
                      mode: "add",
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Daftar denda',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            DendaCard(
              title: 'terlambat',
              nominal: 5000,
            ),
            const SizedBox(height: 14),
            DendaCard(
              title: 'rusak',
              nominal: 5000,
            ),
          ],
        ),
      ),
    );
  }
}
