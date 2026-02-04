import 'package:aplikasi_lispin/models/alat_models.dart';
import 'package:flutter/material.dart';

class AlatPeminjamCard extends StatelessWidget {
  final AlatModel alat;
  final VoidCallback onAddToCart;

  const AlatPeminjamCard({
    super.key,
    required this.alat,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // selalu hijau
    final statusColor = Colors.green;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  alat.namaAlat ?? '',
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
                  color: statusColor.withOpacity(0.2), // background hijau muda
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Tersedia',
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor, // teks hijau
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ===== GAMBAR (TAP MASUK KERANJANG) =====
          Expanded(
            child: GestureDetector(
              onTap: onAddToCart,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: alat.gambarUrl != null && alat.gambarUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          alat.gambarUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.handyman,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ===== FOOTER =====
          Text(
            alat.namaKategori ?? '',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
