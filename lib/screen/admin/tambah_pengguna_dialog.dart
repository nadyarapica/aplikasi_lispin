// screen/admin/tambah_pengguna_dialog.dart
import 'package:aplikasi_lispin/services/pengguna_service.dart';
import 'package:flutter/material.dart';

class TambahPenggunaDialog extends StatefulWidget {
  final Map<String, dynamic>? dataPengguna;
  final VoidCallback? onDataUpdated;

  const TambahPenggunaDialog({
    super.key,
    this.dataPengguna,
    this.onDataUpdated,
  });

  @override
  State<TambahPenggunaDialog> createState() => _TambahPenggunaDialogState();
}

class _TambahPenggunaDialogState extends State<TambahPenggunaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _penggunaService = PenggunaService();

  bool _isLoading = false;
  bool _isEditMode = false;

  // ─── FIX UTAMA ────────────────────────────────────────────────────
  // Nilai dropdown HARUS lowercase agar:
  //   1. Cocok dengan CHECK constraint di DB:
  //        role = ANY (ARRAY['admin','petugas','peminjam'])
  //   2. Saat edit, value dari DB (lowercase) langsung ditemukan di items
  //        → tidak ada assertion "0 or 2+ items with the same value"
  static const List<String> _roles = ['admin', 'petugas', 'peminjam'];

  // Simpan pilihan role di state (bukan TextEditingController)
  String? _selectedRole;

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.dataPengguna != null;

    if (_isEditMode) {
      _namaController.text = widget.dataPengguna!['nama'] ?? '';
      _emailController.text = widget.dataPengguna!['username'] ?? '';

      // role dari DB sudah lowercase → langsung assign
      // toLowerCase() sebagai safety net kalau ada data lama yang title-case
      final roleFromDb = (widget.dataPengguna!['role'] as String?)?.toLowerCase();
      _selectedRole = _roles.contains(roleFromDb) ? roleFromDb : null;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── SIMPAN ───────────────────────────────────────────────────────
  Future<void> _savePengguna() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditMode) {
        await _penggunaService.updatePengguna(
          idUser: widget.dataPengguna!['id_user'],
          nama: _namaController.text.trim(),
          username: _emailController.text.trim(),
          role: _selectedRole!, // sudah lowercase
        );
      } else {
        await _penggunaService.tambahPengguna(
          nama: _namaController.text.trim(),
          username: _emailController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole!, // sudah lowercase
        );
      }

      // Callback sebelum pop agar list di-refresh
      widget.onDataUpdated?.call();

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Pengguna berhasil diupdate'
                  : 'Pengguna berhasil ditambahkan',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── BUILD ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Judul ──
                  Text(
                    _isEditMode ? 'Edit Pengguna' : 'Tambah Pengguna',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── Nama ──
                  TextFormField(
                    controller: _namaController,
                    decoration: _inputDecoration('Nama'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      if (value.trim().length < 3) {
                        return 'Nama minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Role (Dropdown) ──────────────────────────────────
                  // FIX: value = _selectedRole (String? dari state)
                  //      items  = _roles (list of lowercase strings)
                  //      Keduanya pakai tipe yang sama → tidak akan assertion.
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: _inputDecoration('Role'),
                    items: _roles.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        // Tampilkan huruf pertama kapital di UI
                        child: Text(role[0].toUpperCase() + role.substring(1)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedRole = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Role wajib dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Email / Username ──
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Email / Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!_emailRegex.hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Password (hanya saat TAMBAH) ──
                  if (!_isEditMode) ...[
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration('Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 28),

                  // ── Tombol Batal & Simpan ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
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
                        onPressed: _isLoading ? null : _savePengguna,
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
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Simpan',
                                style: TextStyle(color: Colors.black),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helper: dekorasi input yang seragam ─────────────────────────
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.orange),
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
    );
  }
}