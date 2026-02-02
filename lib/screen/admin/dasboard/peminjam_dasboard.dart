import 'package:flutter/material.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DasboardPeminjam extends StatefulWidget {
  const DasboardPeminjam({super.key});

  @override
  State<DasboardPeminjam> createState() => _DasboardPeminjamState();
}

class _DasboardPeminjamState extends State<DasboardPeminjam> {
  final supabase = Supabase.instance.client;

  int totalAlat = 0;
  int menunggu = 0;
  int disetujui = 0;
  int totalPeminjam = 0;

  List<Map<String, dynamic>> aktivitas = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      // ======================
      // TOTAL ALAT
      // ======================
      final alatRes = await supabase.from('alat').select('id_alat');
      totalAlat = alatRes.length;

      // ======================
      // MENUNGGU PERSETUJUAN
      // ======================
      final menungguRes = await supabase
          .from('peminjaman')
          .select('id_peminjaman')
          .eq('status', 'menunggu');

      menunggu = menungguRes.length;

      // ======================
      // DISETUJUI
      // ======================
      final disetujuiRes = await supabase
          .from('peminjaman')
          .select('id_peminjaman')
          .eq('status', 'disetujui');

      disetujui = disetujuiRes.length;

      // ======================
      // TOTAL PEMINJAM
      // ======================
      final peminjamRes = await supabase
          .from('users')
          .select('id_user')
          .eq('role', 'peminjam');

      totalPeminjam = peminjamRes.length;

      // ======================
      // AKTIVITAS TERBARU
      // ======================
      final aktivitasRes = await supabase
          .from('peminjaman')
          .select('''
            id_peminjaman,
            status,
            tanggal_pinjam,
            users (
              nama
            )
          ''')
          .order('id_peminjaman', ascending: false)
          .limit(3);

      aktivitas = List<Map<String, dynamic>>.from(aktivitasRes);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat dashboard')),
      );
    }
  }

  String formatTanggal(String? tanggal) {
    if (tanggal == null) return '-';

    final dt = DateTime.tryParse(tanggal);
    if (dt == null) return '-';

    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String judulAktivitas(String status) {
    switch (status) {
      case 'menunggu':
        return 'meminjam alat';
      case 'disetujui':
        return 'peminjaman disetujui';
      case 'selesai':
        return 'pengembalian';
      default:
        return status;
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
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'dasboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      drawer: const CustomSidebar(
        role: UserRole.peminjam,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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
                      _StatItem(
                        icon: Icons.flash_on,
                        value: totalAlat.toString(),
                        label: 'Total Alat',
                      ),
                      _StatItem(
                        icon: Icons.assignment,
                        value: menunggu.toString(),
                        label: 'Menunggu Persetujuan',
                      ),
                      _StatItem(
                        icon: Icons.folder,
                        value: disetujui.toString(),
                        label: 'Disetujui',
                      ),
                      _StatItem(
                        icon: Icons.inventory,
                        value: totalPeminjam.toString(),
                        label: 'total peminjam',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Aktivitas terbaru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  ...aktivitas.map((e) {
                    final user = e['users'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ActivityItem(
                        title: judulAktivitas(e['status'] ?? ''),
                        name: user?['nama'] ?? '-',
                        unit: '-',
                        date: formatTanggal(e['tanggal_pinjam']),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}

// ==============================
// WIDGET DI BAWAH INI
// UI TIDAK DIUBAH
// ==============================

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE082),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String name;
  final String unit;
  final String date;

  const _ActivityItem({
    required this.title,
    required this.name,
    required this.unit,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepOrange,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepOrange),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time,
              size: 18,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                unit,
                style: const TextStyle(fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
