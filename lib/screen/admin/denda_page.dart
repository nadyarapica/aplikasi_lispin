// screen/admin/denda_page.dart
import 'package:aplikasi_lispin/models/denda_models.dart';
import 'package:aplikasi_lispin/screen/admin/denda_card.dart';
import 'package:aplikasi_lispin/screen/admin/tambah_denda_dialog.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:aplikasi_lispin/services/denda_services.dart';
import 'package:flutter/material.dart';

class DendaPage extends StatefulWidget {
  const DendaPage({super.key});

  @override
  State<DendaPage> createState() => _DendaPageState();
}

class _DendaPageState extends State<DendaPage> {
  final DendaService _service = DendaService();
  final TextEditingController _searchController = TextEditingController();

  List<DendaModel> _dendaList = [];
  List<DendaModel> _filteredList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final data = await _service.getDenda();
      if (!mounted) return;
      setState(() {
        _dendaList = data;
        _filteredList = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showSnackbar('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchPengembalianList() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      ),
    );

    try {
      final list = await _service.getPengembalianList();
      if (mounted) Navigator.pop(context);
      return list;
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        _showSnackbar('Gagal mengambil data pengembalian: $e');
      }
      return null;
    }
  }

  void _searchDenda(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredList = _dendaList;
      } else {
        final q = query.trim();
        _filteredList = _dendaList.where((d) {
          return d.id.toString().contains(q) ||
              d.hariTerlambat.toString().contains(q) ||
              d.dendaPerHari.toString().contains(q) ||
              d.totalDenda.toString().contains(q);
        }).toList();
      }
    });
  }

  // ================= TAMBAH =================
  Future<void> _tambahDenda() async {
    final pengembalianList = await _fetchPengembalianList();
    if (pengembalianList == null || !mounted) return;

    final res = await showDendaDialog(
      context: context,
      mode: 'add',
      pengembalianList: pengembalianList,
    );

    if (res == null || !mounted) return;

    try {
      await _service.tambahDenda(
        DendaModel(
          id: 0,
          idPengembalian: res['id_pengembalian'],
          hariTerlambat: res['hari_terlambat'],
          dendaPerHari: res['denda_per_hari'],
          totalDenda: res['total_denda'], // ✅ langsung dari dialog
        ),
      );

      await _loadData();
      if (mounted) _showSnackbar('Denda berhasil ditambahkan');
    } catch (e) {
      if (mounted) _showSnackbar('Error: $e');
    }
  }

  // ================= EDIT =================
  Future<void> _editDenda(DendaModel denda) async {
    final pengembalianList = await _fetchPengembalianList();
    if (pengembalianList == null || !mounted) return;

    final res = await showDendaDialog(
      context: context,
      mode: 'edit',
      pengembalianList: pengembalianList,
      initialHariTerlambat: denda.hariTerlambat.toString(),
      initialDendaPerHari: denda.dendaPerHari.toString(),
      initialIdPengembalian: denda.idPengembalian,
    );

    if (res == null || !mounted) return;

    try {
      await _service.editDenda(
        denda.id,
        DendaModel(
          id: denda.id,
          idPengembalian: res['id_pengembalian'],
          hariTerlambat: res['hari_terlambat'],
          dendaPerHari: res['denda_per_hari'],
          totalDenda: res['total_denda'], // ✅ langsung dari dialog
        ),
      );

      await _loadData();
      if (mounted) _showSnackbar('Denda berhasil diupdate');
    } catch (e) {
      if (mounted) _showSnackbar('Error: $e');
    }
  }

  Future<void> _hapusDenda(DendaModel denda) async {
    final res = await showDendaDialog(
      context: context,
      mode: 'delete',
      pengembalianList: [],
    );

    if (res == null || res['delete'] != true || !mounted) return;

    try {
      await _service.hapusDenda(denda.id);
      await _loadData();
      if (mounted) _showSnackbar('Denda berhasil dihapus');
    } catch (e) {
      if (mounted) _showSnackbar('Error: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomSidebar(role: UserRole.admin),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Denda', style: TextStyle(color: Colors.black)),
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
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Cari denda...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: _searchDenda,
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchController.clear();
                                _filteredList = _dendaList;
                              });
                            },
                            child: const Icon(Icons.close,
                                size: 18, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 42,
                  width: 42,
                  child: ElevatedButton(
                    onPressed: _tambahDenda,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Daftar Denda',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    )
                  : _filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.receipt_long,
                                  size: 64, color: Colors.grey),
                              const SizedBox(height: 12),
                              Text(
                                _searchController.text.isNotEmpty
                                    ? 'Tidak ada hasil pencarian'
                                    : 'Belum ada denda',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          color: Colors.orange,
                          child: ListView.separated(
                            itemCount: _filteredList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final d = _filteredList[index];
                              return DendaCard(
                                dendaData: {
                                  'id_denda': d.id,
                                  'hari_terlambat': d.hariTerlambat,
                                  'denda_per_hari': d.dendaPerHari,
                                  'id_pengembalian': d.idPengembalian,
                                  'tanggal_pengembalian': null,
                                },
                                onEdit: () => _editDenda(d),
                                onDelete: () => _hapusDenda(d),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
