import 'package:aplikasi_lispin/models/kategori_models.dart';
import 'package:aplikasi_lispin/services/kategori_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahEditKategoriDialog extends StatefulWidget {
  final KategoriModel? kategori;
  final VoidCallback? onDataUpdated;

  const TambahEditKategoriDialog({
    super.key,
    this.kategori,
    this.onDataUpdated,
  });

  @override
  State<TambahEditKategoriDialog> createState() => _TambahEditKategoriDialogState();
}

class _TambahEditKategoriDialogState extends State<TambahEditKategoriDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _kategoriService = KategoriService();
  final SupabaseClient _supabase = Supabase.instance.client;
  
  bool _isLoading = false;
  bool _isEditMode = false;
  int? _kategoriId;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.kategori != null;
    
    if (_isEditMode) {
      _namaController.text = widget.kategori!.namaKategori;
      _deskripsiController.text = widget.kategori!.deskripsi;
      _kategoriId = widget.kategori!.idKategori;
      
      print('Dialog edit mode, ID: $_kategoriId');
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _saveKategori() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditMode && _kategoriId != null) {
        print('Mengupdate kategori ID: $_kategoriId');
        
        await _kategoriService.updateKategori(
          idKategori: _kategoriId!,
          namaKategori: _namaController.text,
          deskripsi: _deskripsiController.text,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kategori berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final result = await _kategoriService.tambahKategori(
          namaKategori: _namaController.text,
          deskripsi: _deskripsiController.text,
        );
        
        print('Kategori ditambahkan: $result');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kategori berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (widget.onDataUpdated != null) {
        widget.onDataUpdated!();
      }

      Navigator.pop(context);
    } catch (e) {
      print('Error save kategori: $e');
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE dengan ID (jika edit)
              Column(
                children: [
                  Text(
                    _isEditMode ? "Edit Kategori" : "Tambah Kategori",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_isEditMode && _kategoriId != null)
                    Text(
                      'ID: $_kategoriId',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nama Kategori",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama kategori',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kategori wajib diisi';
                  }
                  if (value.length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              /// DESKRIPSI
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Deskripsi",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi kategori',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  if (value.length < 5) {
                    return 'Deskripsi minimal 5 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 22),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveKategori,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(42),
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
                          : Text(
                              _isEditMode ? "Update" : "Simpan",
                              style: const TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HapusKategoriDialog extends StatefulWidget {
  final KategoriModel kategori;
  final VoidCallback? onDataUpdated;

  const HapusKategoriDialog({
    super.key,
    required this.kategori,
    this.onDataUpdated,
  });

  @override
  State<HapusKategoriDialog> createState() => _HapusKategoriDialogState();
}

class _HapusKategoriDialogState extends State<HapusKategoriDialog> {
  final _kategoriService = KategoriService();
  final SupabaseClient _supabase = Supabase.instance.client; // TAMBAHKAN INI
  bool _isLoading = false;
  bool _hapusAlatJuga = false;

  Future<void> _deleteKategori() async {
    setState(() => _isLoading = true);

    try {
      print('Menghapus kategori dengan ID: ${widget.kategori.idKategori}');
      
      if (widget.kategori.jumlahAlat > 0 && _hapusAlatJuga) {
        await _supabase
            .from('alat')
            .delete()
            .eq('id_kategori', widget.kategori.idKategori);
        
        print('Menghapus ${widget.kategori.jumlahAlat} alat terkait');
      }
      else if (widget.kategori.jumlahAlat > 0 && !_hapusAlatJuga) {
        await _supabase
            .from('alat')
            .update({'id_kategori': null})
            .eq('id_kategori', widget.kategori.idKategori);
        
        print('Mengupdate ${widget.kategori.jumlahAlat} alat menjadi tanpa kategori');
      }

      await _kategoriService.hapusKategori(widget.kategori.idKategori);
      
      if (widget.onDataUpdated != null) {
        widget.onDataUpdated!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      print('Error delete kategori: $e');
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Hapus Kategori",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.orange,
            ),

            const SizedBox(height: 16),

            Text(
              "Apakah kamu yakin ingin menghapus kategori ini?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '"${widget.kategori.namaKategori}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            if (widget.kategori.jumlahAlat > 0) ...[
              const SizedBox(height: 16),
              
              Card(
                color: Colors.orange.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info, size: 16, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Terdapat alat dalam kategori ini',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.kategori.jumlahAlat} alat ditemukan',
                        style: const TextStyle(fontSize: 14),
                      ),
                      
                      Column(
                        children: [
                          RadioListTile<bool>(
                            title: const Text('Simpan alat (hapus kategori saja)'),
                            subtitle: const Text('Alat akan tetap ada tanpa kategori'),
                            value: false,
                            groupValue: _hapusAlatJuga,
                            onChanged: (value) {
                              setState(() {
                                _hapusAlatJuga = value!;
                              });
                            },
                            dense: true,
                          ),
                          RadioListTile<bool>(
                            title: const Text('Hapus semua alat juga'),
                            subtitle: const Text('Kategori dan semua alat akan dihapus'),
                            value: true,
                            groupValue: _hapusAlatJuga,
                            onChanged: (value) {
                              setState(() {
                                _hapusAlatJuga = value!;
                              });
                            },
                            dense: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _deleteKategori,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(42),
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
                            "Hapus",
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