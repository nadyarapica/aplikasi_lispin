import 'package:flutter/material.dart';
import 'cart_manager.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  @override
  Widget build(BuildContext context) {
    final items = CartManager.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Peminjaman'),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final alat = items[index];
                return ListTile(
                  title: Text(alat.namaAlat ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        CartManager.remove(alat.idAlat);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
