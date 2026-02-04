import 'package:flutter/material.dart';

class PeminjamanCard extends StatelessWidget {
  final String nama;
  final String tanggal;
  final String status;
  final Color statusColor;
  final VoidCallback? onTapApprove;
  final VoidCallback? onTapReject;

  const PeminjamanCard({
    super.key,
    required this.nama,
    required this.tanggal,
    required this.status,
    required this.statusColor,
    this.onTapApprove,
    this.onTapReject, required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(tanggal, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status, style: const TextStyle(color: Colors.white)),
                ),
                const Spacer(),
                if (status.toLowerCase() == 'menunggu') ...[
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: onTapApprove,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onTapReject,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
