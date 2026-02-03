import 'package:aplikasi_lispin/models/alat_models.dart';
import 'package:aplikasi_lispin/screen/admin/widgets/sidebar.dart';
import 'package:aplikasi_lispin/screen/peminjam/card_alat_peminjam.dart';
import 'package:aplikasi_lispin/screen/peminjam/cart_manager.dart';
import 'package:aplikasi_lispin/screen/peminjam/keranjang_page.dart';
import 'package:aplikasi_lispin/services/alat_service.dart';
import 'package:flutter/material.dart';

class AlatPeminjamPage extends StatefulWidget {
  const AlatPeminjamPage({super.key});

  @override
  State<AlatPeminjamPage> createState() => _AlatPeminjamScreenState();
}

class _AlatPeminjamScreenState extends State<AlatPeminjamPage> {
  final AlatService _alatService = AlatService();
  List<AlatModel> _alatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlat();
  }

  Future<void> _loadAlat() async {
    final data = await _alatService.getAlat();
    setState(() {
      _alatList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alat'),
      ),

      drawer: const CustomSidebar(role: UserRole.peminjam),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.8,
              ),
              itemCount: _alatList.length,
              itemBuilder: (context, index) {
                final alat = _alatList[index];

                return AlatPeminjamCard(
                  alat: alat,
                  onAddToCart: () {
                    CartManager.add(alat);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alat masuk keranjang'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const KeranjangPage(),
            ),
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
