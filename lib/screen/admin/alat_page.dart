import 'package:aplikasi_lispin/models/alat_models.dart';
import 'package:aplikasi_lispin/screen/admin/tambah_alat_dialog.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:aplikasi_lispin/services/alat_service.dart';
import 'package:flutter/material.dart';

class AlatScreen extends StatefulWidget {
  const AlatScreen({super.key});

  @override
  State<AlatScreen> createState() => _AlatScreenState();
}

class _AlatScreenState extends State<AlatScreen> {
  final AlatService _alatService = AlatService();
  final TextEditingController _searchController = TextEditingController();
  
  List<AlatModel> _alatList = [];
  List<AlatModel> _filteredList = [];
  List<KategoriDropdown> _kategoriFilterList = [];
  KategoriDropdown? _selectedFilterKategori;
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadAlat();
    _loadKategoriFilter();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAlat() async {
    setState(() => _isLoading = true);
    try {
      final data = await _alatService.getAlat();
      setState(() {
        _alatList = data;
        _filteredList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Gagal memuat data alat: $e');
    }
  }

  Future<void> _loadKategoriFilter() async {
    try {
      final kategori = await _alatService.getKategoriDropdown();
      setState(() {
        _kategoriFilterList = kategori;
      });
    } catch (e) {
      print('Error load kategori filter: $e');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    
    if (query.isEmpty && _selectedFilterKategori == null) {
      setState(() {
        _filteredList = _alatList;
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    
    List<AlatModel> filtered = _alatList;
    
    if (query.isNotEmpty) {
      filtered = filtered.where((alat) {
        return alat.namaAlat.toLowerCase().contains(query.toLowerCase()) ||
               (alat.namaKategori ?? '').toLowerCase().contains(query.toLowerCase()) ||
               alat.kondisi.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    
    if (_selectedFilterKategori != null) {
      filtered = filtered.where((alat) {
        return alat.idKategori == _selectedFilterKategori!.idKategori;
      }).toList();
    }
    
    setState(() => _filteredList = filtered);
  }

  void _onFilterByKategori(KategoriDropdown? kategori) {
    setState(() {
      _selectedFilterKategori = kategori;
    });
    _onSearchChanged();
  }

  void _clearFilter() {
    setState(() {
      _selectedFilterKategori = null;
      _searchController.clear();
    });
    _onSearchChanged();
  }

  void _showTambahAlat() {
    showDialog(
      context: context,
      builder: (context) => TambahEditAlatDialog(
        onDataUpdated: _loadAlat,
      ),
    );
  }

  void _showEditAlat(AlatModel alat) {
    showDialog(
      context: context,
      builder: (context) => TambahEditAlatDialog(
        alat: alat,
        onDataUpdated: _loadAlat,
      ),
    );
  }

  void _showDeleteAlat(AlatModel alat) {
    showDialog(
      context: context,
      builder: (context) => HapusAlatDialog(
        alat: alat,
        onDataUpdated: _loadAlat,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baik':
        return Colors.green;
      case 'buruk':
        return Colors.red;
      case 'rusak':
        return Colors.orange;
      case 'dalam perbaikan':
        return Colors.blue;
      default:
        return Colors.grey;
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
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text(
          'Alat',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadAlat,
          ),
        ],
      ),
        drawer: CustomSidebar(role: UserRole.admin),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SEARCH BAR
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
                        hintText: 'Cari alat...',
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
                    onTap: _showTambahAlat,
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // FILTER CHIPS
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  // Filter kategori dropdown
                  if (_kategoriFilterList.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<KategoriDropdown>(
                          value: _selectedFilterKategori,
                          hint: const Text(
                            'Semua Kategori',
                            style: TextStyle(fontSize: 11),
                          ),
                          items: [
                            const DropdownMenuItem<KategoriDropdown>(
                              value: null,
                              child: Text('Semua Kategori', style: TextStyle(fontSize: 11)),
                            ),
                            ..._kategoriFilterList.map((kategori) {
                              return DropdownMenuItem<KategoriDropdown>(
                                value: kategori,
                                child: Text(kategori.namaKategori, style: const TextStyle(fontSize: 11)),
                              );
                            }).toList(),
                          ],
                          onChanged: _onFilterByKategori,
                          icon: const Icon(Icons.arrow_drop_down, size: 16),
                          isDense: true,
                        ),
                      ),
                    ),
                  
                  const SizedBox(width: 8),
                  
                  // Clear filter button
                  if (_selectedFilterKategori != null || _searchController.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: _clearFilter,
                        child: Row(
                          children: [
                            const Icon(Icons.clear, size: 14, color: Colors.red),
                            const SizedBox(width: 4),
                            const Text(
                              'Clear',
                              style: TextStyle(fontSize: 11, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

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
                                _isSearching ? Icons.search_off : Icons.handyman_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isSearching 
                                    ? 'Tidak ada hasil pencarian'
                                    : 'Belum ada alat',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadAlat,
                          color: Colors.orange,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final alat = _filteredList[index];
                              return AlatCard(
                                alat: alat,
                                onEdit: () => _showEditAlat(alat),
                                onDelete: () => _showDeleteAlat(alat),
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

class HapusAlatDialog extends StatefulWidget {
  final AlatModel alat;
  final VoidCallback? onDataUpdated;

  const HapusAlatDialog({
    super.key,
    required this.alat,
    this.onDataUpdated,
  });

  @override
  State<HapusAlatDialog> createState() => _HapusAlatDialogState();
}

class _HapusAlatDialogState extends State<HapusAlatDialog> {
  final _alatService = AlatService();
  bool _isLoading = false;

  Future<void> _deleteAlat() async {
    setState(() => _isLoading = true);

    try {
      await _alatService.hapusAlat(widget.alat.idAlat);
      
      if (widget.onDataUpdated != null) {
        widget.onDataUpdated!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alat berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      print('Error delete alat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: Colors.orange,
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Hapus Alat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              '"${widget.alat.namaAlat}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            if (widget.alat.namaKategori != null)
              Text(
                'Kategori: ${widget.alat.namaKategori}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            
            const SizedBox(height: 8),
            
            Text(
              'Stok: ${widget.alat.stok} | Kondisi: ${widget.alat.kondisi}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Apakah kamu yakin ingin menghapus alat ini?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _deleteAlat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Hapus',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CARD ALAT =================
class AlatCard extends StatelessWidget {
  final AlatModel alat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlatCard({
    super.key,
    required this.alat,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baik':
        return Colors.green;
      case 'buruk':
        return Colors.red;
      case 'rusak':
        return Colors.orange;
      case 'dalam perbaikan':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(alat.kondisi);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  alat.namaAlat,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  alat.kondisi,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // IMAGE atau ICON
          Expanded(
            child: Center(
              child: _buildImagePreview(),
            ),
          ),

          const SizedBox(height: 8),

          // FOOTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (alat.namaKategori != null)
                      Text(
                        alat.namaKategori!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      'Stok: ${alat.stok}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: const Icon(Icons.edit, size: 16, color: Colors.blue),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.delete, size: 16, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (alat.gambarUrl != null && alat.gambarUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          alat.gambarUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.handyman,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}