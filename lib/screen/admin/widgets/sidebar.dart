import 'package:aplikasi_lispin/screen/peminjam/alat_peminjam_page.dart' show AlatPeminjamScreen;
import 'package:aplikasi_lispin/screen/peminjam/dasboard_peminjam.dart';
import 'package:aplikasi_lispin/screen/peminjam/peminjaman_page.dart';
import 'package:aplikasi_lispin/screen/peminjam/pengembalian_page.dart';
import 'package:aplikasi_lispin/screen/petugas/laporan_petugas.dart';
import 'package:flutter/material.dart';

// ===== IMPORT PAGE =====
// ADMIN
import 'package:aplikasi_lispin/screen/admin/dasboard/admin_dasboard.dart';
import 'package:aplikasi_lispin/screen/admin/alat_page.dart';
import 'package:aplikasi_lispin/screen/admin/kategori_page.dart';
import 'package:aplikasi_lispin/screen/admin/riwayat_page.dart';
import 'package:aplikasi_lispin/screen/admin/denda_page.dart';
import 'package:aplikasi_lispin/screen/admin/log_aktivitas_page.dart';
import 'package:aplikasi_lispin/screen/admin/pengguna_page.dart';

// PETUGAS
import 'package:aplikasi_lispin/screen/petugas/peminjaman_petugas_page.dart';
import 'package:aplikasi_lispin/screen/petugas/pengembalian_petugas_page.dart';

enum UserRole { admin, petugas, peminjam }

class CustomSidebar extends StatelessWidget {
  final UserRole role;

  const CustomSidebar({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFF3E0),
      width: 280,
      child: Column(
        children: [
          /// ===== HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFFF9800),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nadya Rapica',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  role.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          /// ===== MENU =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  ..._buildMenuByRole(context),

                  const SizedBox(height: 40),

                  _SidebarItem(
                    title: 'Log Out',
                    icon: Icons.logout,
                    isLogout: true,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===== MENU BERDASARKAN ROLE =====
  List<Widget> _buildMenuByRole(BuildContext context) {
    switch (role) {
      case UserRole.admin:
        return [
          _item(context, 'Dashboard', const AdminDashboard()),
          _item(context, 'Alat', const AlatScreen()),
          _item(context, 'Kategori', const KategoriScreen()),
          _item(context, 'Riwayat', const RiwayatPage()),
          _item(context, 'Denda', const DendaPage()),
          _item(context, 'Log Aktivitas', const LogAktivitasPage()),
          _item(context, 'Pengguna', const PenggunaScreen()),
        ];

      case UserRole.petugas:
        return [
          // _item(context, 'Dashboard Petugas', const DashboardPetugasPage()),
          _item(context, 'Peminjaman', const PeminjamanPetugasPage()),
          _item(context, 'Pengembalian', const PengembalianPetugasPage()),
          _item(context, 'Laporan', const LaporanPage()),
        ];

      case UserRole.peminjam:
        return [
          _item(context, 'Dashboard', const DasboardPeminjam()),
          _item(context, 'Alat', const AlatPeminjamScreen()),
          _item(context, 'Peminjaman', const PeminjamanPeminjamPage()), // ✅ FIX
          _item(context, 'Pengembalian', const PengembalianpeminjamPage()),
        ];
    }
  }

  Widget _item(BuildContext context, String title, Widget page) {
    return _SidebarItem(
      title: title,
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}

/// ===== ITEM =====
class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isLogout;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.title,
    this.icon,
    this.isLogout = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        elevation: 1.5,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: [
                Icon(
                  icon ?? Icons.chevron_right_rounded,
                  color: isLogout ? Colors.red : const Color(0xFFFF9800),
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isLogout ? Colors.red : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
