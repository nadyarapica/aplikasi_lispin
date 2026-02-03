// screen/admin/denda_card.dart
import 'package:flutter/material.dart';

class DendaCard extends StatelessWidget {
  final Map<String, dynamic> dendaData; // Data dari Supabase
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DendaCard({
    super.key,
    required this.dendaData,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data dari Supabase
    final int hariTerlambat = dendaData['hari_terlambat'] ?? 0;
    final int dendaPerHari = dendaData['denda_per_hari'] ?? 0;

    // ✅ ambil langsung dari Supabase
    final int totalDenda = dendaData['total_denda'] ?? 0;

    // Optional: ambil data tambahan seperti id_pengembalian, tanggal, dll
    final String? tanggalPengembalian = dendaData['tanggal_pengembalian'];
    final int? idPengembalian = dendaData['id_pengembalian'];

    // Format title
    String title = 'Denda #${dendaData['id_denda'] ?? '-'}';

    // Format subtitle
    String? subtitle;
    if (idPengembalian != null) {
      subtitle = 'Pengembalian #$idPengembalian';
      if (tanggalPengembalian != null) {
        subtitle += ' • $tanggalPengembalian';
      }
    }

    subtitle =
        (subtitle ?? '') + '\n$hariTerlambat hari × Rp ${_formatAngka(dendaPerHari)}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFFFF9800),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatAngka(totalDenda)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.blue,
                ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAngka(int angka) {
    return angka.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
