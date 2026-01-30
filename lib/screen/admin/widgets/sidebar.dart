import 'package:flutter/material.dart';

import 'package:aplikasi_lispin/screen/admin/pengguna_page.dart';
import 'package:aplikasi_lispin/screen/admin/alat_page.dart';
import 'package:aplikasi_lispin/screen/admin/kategori_page.dart';
import 'package:aplikasi_lispin/screen/admin/denda_page.dart';
import 'package:aplikasi_lispin/screen/admin/riwayat_page.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFF3E0),
      width: 280,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFFF9800),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Nadya Rapica',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ===== MENU =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  _SidebarItem(
                    title: 'Dasboard',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  _SidebarItem(
                    title: 'Pengguna',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PenggunaScreen(),
                        ),
                      );
                    },
                  ),

                  _SidebarItem(
                    title: 'Alat',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AlatScreen(),
                        ),
                      );
                    },
                  ),

                  _SidebarItem(
                    title: 'Denda',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DendaPage(),
                        ),
                      );
                    },
                  ),

                  _SidebarItem(
                    title: 'Kategori',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KategoriScreen(),
                        ),
                      );
                    },
                  ),

                  // ✅ RIWAYAT — SUDAH BENAR
                  _SidebarItem(
                    title: 'Riwayat',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RiwayatPage(),
                        ),
                      );
                    },
                  ),

                  _SidebarItem(
                    title: 'Log Aktivitas',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

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
}

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
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap ?? () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: [
                Icon(
                  icon ?? Icons.chevron_right_rounded,
                  color: isLogout
                      ? Colors.red[700]
                      : const Color(0xFFFF9800),
                  size: 26,
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isLogout
                        ? Colors.red[800]
                        : Colors.black87,
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
