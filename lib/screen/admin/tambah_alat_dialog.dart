import 'dart:typed_data';
import 'package:aplikasi_lispin/models/alat_models.dart';
import 'package:aplikasi_lispin/services/alat_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahEditAlatDialog extends StatefulWidget {
  final AlatModel? alat;
  final VoidCallback? onDataUpdated;

  const TambahEditAlatDialog({
    super.key,
    this.alat,
    this.onDataUpdated,
  });

  @override
  State<TambahEditAlatDialog> createState() => _TambahEditAlatDialogState();
}

class _TambahEditAlatDialogState extends State<TambahEditAlatDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController(text: '1');
  final _alatService = AlatService();
  final ImagePicker _picker = ImagePicker();
  
  List<KategoriDropdown> _kategoriList = [];
  KategoriDropdown? _selectedKategori;
  String? _selectedKondisi = 'Baik';
  XFile? _selectedImage;
  bool _isLoading = false;
  bool _isEditMode = false;
  int? _alatId;

  // List kondisi
  final List<String> _kondisiList = ['Baik', 'Buruk', 'Rusak', 'Dalam Perbaikan'];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.alat != null;
    
    _loadKategori();
    
    if (_isEditMode) {
      _namaController.text = widget.alat!.namaAlat;
      _stokController.text = widget.alat!.stok.toString();
      _selectedKondisi = widget.alat!.kondisi;
      _alatId = widget.alat!.idAlat;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  Future<void> _loadKategori() async {
    try {
      final kategori = await _alatService.getKategoriDropdown();
      
      if (!mounted) return;
      
      setState(() {
        _kategoriList = kategori;
        
        // Set selected kategori jika edit mode
        if (_isEditMode && widget.alat!.idKategori != null) {
          for (var kategori in _kategoriList) {
            if (kategori.idKategori == widget.alat!.idKategori) {
              _selectedKategori = kategori;
              break;
            }
          }
        }
      });
    } catch (e) {
      print('Error load kategori: $e');
      if (mounted) {
        _showErrorSnackbar('Gagal memuat kategori: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      print('Error pick image: $e');
      _showErrorSnackbar('Gagal memilih gambar: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      print('Error take photo: $e');
      _showErrorSnackbar('Gagal mengambil foto: $e');
    }
  }

  Future<void> _saveAlat() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedKategori == null) {
      _showErrorSnackbar('Pilih kategori alat');
      return;
    }
    
    if (_selectedKondisi == null) {
      _showErrorSnackbar('Pilih kondisi alat');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final stok = int.tryParse(_stokController.text) ?? 1;
      
      if (_isEditMode && _alatId != null) {
        // UPDATE ALAT
        await _alatService.updateAlat(
          idAlat: _alatId!,
          namaAlat: _namaController.text.trim(),
          idKategori: _selectedKategori!.idKategori,
          kondisi: _selectedKondisi!,
          stok: stok,
          imageFile: _selectedImage,
          deleteOldImage: false,
        );
        
        if (!mounted) return;
        _showSuccessSnackbar('Alat berhasil diupdate');
      } else {
        // TAMBAH ALAT BARU
        await _alatService.tambahAlat(
          namaAlat: _namaController.text.trim(),
          idKategori: _selectedKategori!.idKategori,
          kondisi: _selectedKondisi!,
          stok: stok,
          imageFile: _selectedImage,
        );
        
        if (!mounted) return;
        _showSuccessSnackbar('Alat berhasil ditambahkan');
      }

      if (widget.onDataUpdated != null) {
        widget.onDataUpdated!();
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error save alat: $e');
      if (mounted) {
        _showErrorSnackbar('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TITLE
                Text(
                  _isEditMode ? "Edit Alat" : "Tambah Alat",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 22),

                /// NAMA ALAT
                TextFormField(
                  controller: _namaController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Nama Alat',
                    hintText: 'Masukkan nama alat',
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
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama alat wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama minimal 3 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                /// KATEGORI DROPDOWN
                DropdownButtonFormField<KategoriDropdown>(
                  value: _selectedKategori,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 4,
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
                  items: _kategoriList.map((KategoriDropdown kategori) {
                    return DropdownMenuItem<KategoriDropdown>(
                      value: kategori,
                      child: Text(kategori.namaKategori),
                    );
                  }).toList(),
                  onChanged: _isLoading ? null : (KategoriDropdown? newValue) {
                    setState(() {
                      _selectedKategori = newValue;
                    });
                  },
                  hint: const Text('Pilih kategori'),
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih kategori';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                /// STOK
                TextFormField(
                  controller: _stokController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stok',
                    hintText: 'Masukkan jumlah stok',
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
                      return 'Stok wajib diisi';
                    }
                    final stok = int.tryParse(value);
                    if (stok == null) {
                      return 'Stok harus angka';
                    }
                    if (stok < 1) {
                      return 'Stok minimal 1';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    // GAMBAR
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gambar Alat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _isLoading ? null : _showImagePickerOptions,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.orange),
                                color: Colors.grey[100],
                              ),
                              child: _buildImagePreview(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _isLoading ? null : _showImagePickerOptions,
                            child: const Text(
                              'Pilih Gambar',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // KONDISI DROPDOWN
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedKondisi,
                        decoration: InputDecoration(
                          labelText: 'Kondisi',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 4,
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
                        items: _kondisiList.map((String kondisi) {
                          return DropdownMenuItem<String>(
                            value: kondisi,
                            child: Text(kondisi),
                          );
                        }).toList(),
                        onChanged: _isLoading ? null : (String? newValue) {
                          setState(() {
                            _selectedKondisi = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih kondisi';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                /// BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(110, 40),
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
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveAlat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(110, 40),
                        elevation: 0,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return FutureBuilder<Uint8List>(
        future: _selectedImage!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          }
          
          if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
            );
          } else if (snapshot.hasError) {
            return const Icon(
              Icons.image,
              size: 40,
              color: Colors.orange,
            );
          } else {
            return const Icon(
              Icons.image,
              size: 40,
              color: Colors.orange,
            );
          }
        },
      );
    } else if (_isEditMode && widget.alat?.gambarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          widget.alat!.gambarUrl!,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image,
              size: 40,
              color: Colors.orange,
            );
          },
        ),
      );
    } else {
      return const Icon(
        Icons.image,
        size: 40,
        color: Colors.orange,
      );
    }
  }

  void _showImagePickerOptions() {
    if (_isLoading) return;
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              if (_selectedImage != null || widget.alat?.gambarUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus Gambar', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}