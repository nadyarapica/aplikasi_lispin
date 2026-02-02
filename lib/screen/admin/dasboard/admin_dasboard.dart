import 'package:flutter/material.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/activity_card.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/stat_card.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;

  int totalUser = 0;
  int totalAlat = 0;
  int totalKategori = 0;
  int totalPeminjam = 0;

  List<Map<String, dynamic>> aktivitas = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      // ======================
      // TOTAL USER - Gunakan select() seperti di pengguna_service
      // ======================
      final userRes = await supabase
          .from('users')
          .select();

      // ======================
      // TOTAL ALAT
      // ======================
      final alatRes = await supabase
          .from('alat')
          .select();

      // ======================
      // TOTAL KATEGORI
      // ======================
      final kategoriRes = await supabase
          .from('kategori')
          .select();

      // ======================
      // TOTAL PEMINJAMAN
      // ======================
      final peminjamRes = await supabase
          .from('peminjaman')
          .select();

      // ======================
      // AKTIVITAS TERBARU
      // ======================
      final aktivitasRes = await supabase
          .from('peminjaman')
          .select('''
            id_peminjaman,
            tanggal_pinjam,
            id_user,
            detail_peminjaman (
              jumlah,
              alat (
                nama_alat
              )
            )
          ''')
          .order('id_peminjaman', ascending: false)
          .limit(3);

      debugPrint('===== DEBUG DATA =====');
      debugPrint('Total Users: ${(userRes as List).length}');
      debugPrint('Total Alat: ${(alatRes as List).length}');
      debugPrint('Total Kategori: ${(kategoriRes as List).length}');
      debugPrint('Total Peminjaman: ${(peminjamRes as List).length}');
      debugPrint('Aktivitas Raw: $aktivitasRes');
      debugPrint('=====================');

      // Flatten data aktivitas untuk menampilkan semua detail peminjaman
      List<Map<String, dynamic>> flattenedAktivitas = [];
      
      // Buat map untuk cache user data agar tidak query berulang
      Map<String, String> userCache = {};
      
      for (var peminjaman in aktivitasRes as List) {
        final detailList = peminjaman['detail_peminjaman'] as List?;
        final idUser = peminjaman['id_user'] as String?;
        
        // Ambil nama user
        String namaUser = '-';
        if (idUser != null) {
          // Cek cache dulu
          if (userCache.containsKey(idUser)) {
            namaUser = userCache[idUser]!;
          } else {
            // Query ke database jika belum ada di cache
            try {
              final userData = await supabase
                  .from('users')
                  .select('nama')
                  .eq('id_user', idUser)
                  .single();
              
              namaUser = userData['nama'] ?? '-';
              userCache[idUser] = namaUser;
            } catch (e) {
              debugPrint('Error getting user $idUser: $e');
            }
          }
        }
        
        if (detailList != null && detailList.isNotEmpty) {
          // Buat entry untuk setiap detail peminjaman
          for (var detail in detailList) {
            flattenedAktivitas.add({
              'id_peminjaman': peminjaman['id_peminjaman'],
              'tanggal_pinjam': peminjaman['tanggal_pinjam'],
              'nama_user': namaUser,
              'detail': detail,
            });
          }
        } else {
          // Jika tidak ada detail, tetap masukkan data peminjaman
          flattenedAktivitas.add({
            'id_peminjaman': peminjaman['id_peminjaman'],
            'tanggal_pinjam': peminjaman['tanggal_pinjam'],
            'nama_user': namaUser,
            'detail': null,
          });
        }
      }

      debugPrint('Flattened Aktivitas: $flattenedAktivitas');

      setState(() {
        totalUser = (userRes as List).length;
        totalAlat = (alatRes as List).length;
        totalKategori = (kategoriRes as List).length;
        totalPeminjam = (peminjamRes as List).length;

        aktivitas = flattenedAktivitas;

        isLoading = false;
      });
    } catch (e, s) {
      debugPrint('===== DASHBOARD ADMIN ERROR =====');
      debugPrint(e.toString());
      debugPrint(s.toString());
      debugPrint('================================');

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat dashboard')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

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
        centerTitle: false,
      ),

      drawer: const CustomSidebar(
        role: UserRole.admin,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        StatCard(
                          icon: Icons.person,
                          value: totalUser.toString(),
                          label: 'pengguna',
                        ),
                        StatCard(
                          icon: Icons.inventory_2,
                          value: totalAlat.toString(),
                          label: 'total alat',
                        ),
                        StatCard(
                          icon: Icons.category,
                          value: totalKategori.toString(),
                          label: 'kategori',
                        ),
                        StatCard(
                          icon: Icons.assignment,
                          value: totalPeminjam.toString(),
                          label: 'total peminjam',
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Aktivitas terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...aktivitas.map((e) {
                      final detail = e['detail'];

                      return ActivityCard(
                        title: detail?['alat']?['nama_alat'] ?? '-',
                        user: e['nama_user'] ?? '-',
                        unit: '${detail?['jumlah'] ?? 0} unit',
                        date: e['tanggal_pinjam']
                                ?.toString()
                                .substring(0, 10) ??
                            '-',
                      );
                    }).toList(),
                  ],
                ),
              ),
      ),
    );
  }
}