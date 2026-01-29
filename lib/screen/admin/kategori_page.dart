import 'package:aplikasi_lispin/models/kategori_models.dart';
import 'package:aplikasi_lispin/screen/admin/tambah_kategori_dialog.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:aplikasi_lispin/services/kategori_service.dart';
import 'package:flutter/material.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final KategoriService _kategoriService = KategoriService();
  final TextEditingController _searchController = TextEditingController();
  
  List<KategoriModel> _kategoriList = [];
  List<KategoriModel> _filteredList = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadKategori();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadKategori() async {
    setState(() => _isLoading = true);
    try {
      final data = await _kategoriService.getKategori();
      
      // Debug: Print semua kategori yang diambil
      print('=== DATA KATEGORI YANG DIAMBIL ===');
      for (var kategori in data) {
        print('ID: ${kategori.idKategori}, Nama: ${kategori.namaKategori}');
      }
      print('==================================');
      
      setState(() {
        _kategoriList = data;
        _filteredList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Gagal memuat data kategori: $e');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _filteredList = _kategoriList;
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    
    final filtered = _kategoriList.where((kategori) {
      return kategori.namaKategori.toLowerCase().contains(query.toLowerCase()) ||
             kategori.deskripsi.toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    setState(() => _filteredList = filtered);
  }

  void _showTambahKategori() {
    showDialog(
      context: context,
      builder: (context) => TambahEditKategoriDialog(
        onDataUpdated: _loadKategori,
      ),
    );
  }

  void _showEditKategori(KategoriModel kategori) {
    print('Edit kategori: $kategori'); // Debug log
    showDialog(
      context: context,
      builder: (context) => TambahEditKategoriDialog(
        kategori: kategori,
        onDataUpdated: _loadKategori,
      ),
    );
  }

  void _showDeleteKategori(KategoriModel kategori) {
    print('Hapus kategori: $kategori'); // Debug log
    showDialog(
      context: context,
      builder: (context) => HapusKategoriDialog(
        kategori: kategori,
        onDataUpdated: _loadKategori,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text(
          'Kategori',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          // Tombol refresh
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadKategori,
          ),
        ],
      ),
      drawer: const CustomSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// SEARCH + ADD
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
                        const Icon(Icons.search, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Cari kategori...',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
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
                  onPressed: _showTambahKategori,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// LOADING / DATA
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    )
                  : _filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isSearching ? Icons.search_off : Icons.category_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isSearching 
                                    ? 'Tidak ada hasil pencarian'
                                    : 'Belum ada kategori',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadKategori,
                          color: Colors.orange,
                          child: ListView.builder(
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final kategori = _filteredList[index];
                              return _KategoriCard(
                                kategori: kategori,
                                onEdit: () => _showEditKategori(kategori),
                                onDelete: () => _showDeleteKategori(kategori),
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

class _KategoriCard extends StatelessWidget {
  final KategoriModel kategori;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KategoriCard({
    required this.kategori,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Icon kategori
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.category,
              color: Colors.orange,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        kategori.namaKategori,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Tampilkan ID untuk debugging
                    Text(
                      'ID: ${kategori.idKategori}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                if (kategori.deskripsi.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      kategori.deskripsi,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.hardware, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Alat: ${kategori.jumlahAlat}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// EDIT
          IconButton(
            icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
            onPressed: onEdit,
            tooltip: 'Edit kategori',
          ),

          /// DELETE - SEMUA BISA DIHAPUS
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 20,
              color: Colors.red,
            ),
            onPressed: onDelete, // Selalu aktif
            tooltip: 'Hapus kategori (${kategori.jumlahAlat} alat akan diupdate)',
          ),
        ],
      ),
    );
  }
}