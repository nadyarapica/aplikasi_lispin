import 'package:flutter/material.dart';
import 'cart_manager.dart';
import 'package:aplikasi_lispin/models/peminjaman_models.dart';
import 'peminjaman_manager.dart';
import 'peminjaman_page.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  DateTime? tanggalPinjam;
  DateTime? tanggalKembali;

  Future<void> _pickTanggalPinjam() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (result != null) {
      setState(() => tanggalPinjam = result);
    }
  }

  Future<void> _pickTanggalKembali() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (result != null) {
      setState(() => tanggalKembali = result);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'dd/mm/yyyy';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final items = CartManager.items;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Keranjang Peminjaman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alat'),
            const SizedBox(height: 10),

            if (items.isEmpty)
              const Center(child: Text('Keranjang kosong'))
            else
              Column(
                children: items.map((alat) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(alat.namaAlat ?? ''),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              CartManager.remove(alat.idAlat);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickTanggalPinjam,
                    child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Text(_formatDate(tanggalPinjam)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickTanggalKembali,
                    child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Text(_formatDate(tanggalKembali)),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (items.isEmpty || tanggalPinjam == null || tanggalKembali == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lengkapi data peminjaman')),
                    );
                    return;
                  }

                  for (var alat in items) {
                    PeminjamanManager.tambah(PeminjamanModel(
                      peminjam: 'Peminjam 1', // bisa diganti sesuai login user
                      namaAlat: alat.namaAlat ?? '',
                      tanggalPinjam: _formatDate(tanggalPinjam),
                      tanggalKembali: _formatDate(tanggalKembali),
                      status: 'menunggu',
                    ));
                  }

                  CartManager.clear();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PeminjamanPage()),
                  );
                },
                child: const Text('Ajukan Peminjaman'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
