import 'package:aplikasi_lispin/models/riwayat_models.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_lispin/screen/admin/filter.dart';
import 'package:aplikasi_lispin/screen/admin/riwayat_card.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import '../../services/riwayat_service.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  String selectedFilter = 'semua';

  final service = RiwayatService();

  List<RiwayatModel> data = [];

  Future<void> loadData() async {
    final result = await service.fetchRiwayat();
    setState(() {
      data = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = selectedFilter == 'semua'
        ? data
        : data.where((e) => e.status == selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomSidebar(role: UserRole.admin),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          'Riwayat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Text('search', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                FilterChipWidget(
                  label: 'semua',
                  active: selectedFilter == 'semua',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'semua';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChipWidget(
                  label: 'peminjam',
                  active: selectedFilter == 'peminjam',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'peminjam';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChipWidget(
                  label: 'pengembalian',
                  active: selectedFilter == 'pengembalian',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'pengembalian';
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: filteredData.map((e) {
                  return RiwayatCard(
                    data: e,
                    onRefresh: loadData,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
