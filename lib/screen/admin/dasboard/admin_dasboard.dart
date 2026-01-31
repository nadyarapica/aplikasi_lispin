import 'package:flutter/material.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/activity_card.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/stat_card.dart';

// Sesuaikan path import sidebar sesuai struktur folder proyek kamu
// Contoh: jika file sidebar ada di lib/widgets/custom_sidebar.dart
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';  // ← GANTI SESUAI PATH KAMU

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Cara paling aman & umum untuk membuka drawer
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false, // biar title di kiri seperti umum
      ),

      // ← Ini bagian penting: hubungkan sidebar ke Scaffold
      drawer: CustomSidebar(role: UserRole.admin),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== STATISTIC CARDS =====
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  StatCard(
                    icon: Icons.person,
                    value: '50',
                    label: 'pengguna',
                  ),
                  StatCard(
                    icon: Icons.inventory_2,
                    value: '4',
                    label: 'total alat',
                  ),
                  StatCard(
                    icon: Icons.category,
                    value: '4',
                    label: 'kategori',
                  ),
                  StatCard(
                    icon: Icons.assignment,
                    value: '10',
                    label: 'total peminjam',
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ===== AKTIVITAS TERBARU =====
              const Text(
                'Aktivitas terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              const ActivityCard(
                title: 'meminjam helm sefty',
                user: 'Egi Dwi',
                unit: '2 unit',
                date: '23/01/2026',
              ),
              const ActivityCard(
                title: 'meminjam multimeter',
                user: 'chella',
                unit: '1 unit',
                date: '22/01/2026',
              ),
              const ActivityCard(
                title: 'mengembalikan clamp meter',
                user: 'melati',
                unit: '1 unit',
                date: '21/01/2026',
              ),
            ],
          ),
        ),
      ),
    );
  }
}