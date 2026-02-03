import 'package:aplikasi_lispin/models/riwayat_models.dart';
import 'package:flutter/material.dart';
import 'tambah_riwayat_dialog.dart';

class RiwayatCard extends StatelessWidget {
  final RiwayatModel data;
  final VoidCallback onRefresh;

  const RiwayatCard({
    super.key,
    required this.data,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.namaUser,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.status,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              showEditRiwayatDialog(
                context,
                namaUser: data.namaUser,
                statusAwal: data.status,
                idPeminjaman: data.idPeminjaman,
                onSuccess: onRefresh,
              );
            },
            child: const Icon(Icons.edit, size: 18),
          ),

          const SizedBox(width: 10),

          InkWell(
            onTap: () {
              showHapusRiwayatDialog(
                context,
                idDetail: data.idDetail,
                onSuccess: onRefresh,
              );
            },
            child: const Icon(Icons.delete, size: 18),
          ),
        ],
      ),
    );
  }
}
