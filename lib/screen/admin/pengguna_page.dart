// screen/admin/pengguna_screen.dart
import 'package:aplikasi_lispin/models/pengguna_models.dart';
import 'package:aplikasi_lispin/screen/admin/tambah_pengguna_dialog.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:aplikasi_lispin/services/pengguna_service.dart';
import 'package:flutter/material.dart';

class PenggunaScreen extends StatefulWidget {
  const PenggunaScreen({super.key});

  @override
  State<PenggunaScreen> createState() => _PenggunaScreenState();
}

class _PenggunaScreenState extends State<PenggunaScreen> {
  final PenggunaService _penggunaService = PenggunaService();
  final TextEditingController _searchController = TextEditingController();

  List<PenggunaModel> _penggunaList = [];
  List<PenggunaModel> _filteredList = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadPengguna();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPengguna() async {
    setState(() => _isLoading = true);
    try {
      final data = await _penggunaService.getPengguna();
      setState(() {
        _penggunaList = data;
        _filteredList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Gagal memuat data pengguna');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _filteredList = _penggunaList;
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final filtered = _penggunaList.where((pengguna) {
      return pengguna.nama.toLowerCase().contains(query.toLowerCase()) ||
          pengguna.username.toLowerCase().contains(query.toLowerCase()) ||
          pengguna.role.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() => _filteredList = filtered);
  }

  void _showTambahPengguna() {
    showDialog(
      context: context,
      builder: (context) => TambahPenggunaDialog(
        onDataUpdated: _loadPengguna,
      ),
    );
  }

  void _showEditPengguna(PenggunaModel pengguna) {
    // ✅ FIX: gunakan context asli dari State, jangan ubah
    showDialog(
      context: context,
      builder: (context) => TambahPenggunaDialog(
        dataPengguna: {
          'id_user': pengguna.idUser,
          'nama': pengguna.nama,
          'role': pengguna.role,
          'username': pengguna.username,
        },
        onDataUpdated: _loadPengguna,
      ),
    );
  }

  void _showDeleteConfirmation(PenggunaModel pengguna) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Hapus Pengguna',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus pengguna "${pengguna.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deletePengguna(pengguna);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              elevation: 0,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePengguna(PenggunaModel pengguna) async {
    try {
      await _penggunaService.hapusPengguna(pengguna.idUser);
      await _loadPengguna();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pengguna.nama} berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'petugas':
        return Colors.blue;
      case 'peminjam':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomSidebar(role: UserRole.admin),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text(
          'Pengguna',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari pengguna...',
                        prefixIcon: Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: GestureDetector(
                    onTap: _showTambahPengguna,
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
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
                              Icon(
                                _isSearching
                                    ? Icons.search_off
                                    : Icons.people_outline,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isSearching
                                    ? 'Tidak ada hasil pencarian'
                                    : 'Belum ada pengguna',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadPengguna,
                          color: Colors.orange,
                          child: ListView.builder(
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              return _penggunaCard(_filteredList[index]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _penggunaCard(PenggunaModel pengguna) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: _getRoleColor(pengguna.role),
            child: const Icon(Icons.person, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pengguna.nama,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  pengguna.username,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        _getRoleColor(pengguna.role).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pengguna.role,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getRoleColor(pengguna.role),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
            onPressed: () => _showEditPengguna(pengguna),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(pengguna),
          ),
        ],
      ),
    );
  }
}
