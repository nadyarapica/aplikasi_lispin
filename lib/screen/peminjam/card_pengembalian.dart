import 'package:flutter/material.dart';

class PengembalianPengembalianCard extends StatefulWidget {
  final String nama;
  final String tanggal;
  final String status;

  const PengembalianPengembalianCard({
    super.key,
    required this.nama,
    required this.tanggal,
    required this.status,
  });

  @override
  State<PengembalianPengembalianCard> createState() => _PengembalianPengembalianCardState();
}

class _PengembalianPengembalianCardState extends State<PengembalianPengembalianCard> {
  bool isExpanded = false;

  Color _statusColor() {
    switch (widget.status.toLowerCase()) {
      case 'pengembalian':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.status.toLowerCase() == 'pengembalian') {
          setState(() => isExpanded = !isExpanded);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.status.toLowerCase() == 'pengembalian'
                          ? 'Dipinjam\n${widget.tanggal}'
                          : 'Kembali\n${widget.tanggal}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            /// DETAIL (HANYA SAAT PENGEMBALIAN)
            if (isExpanded) ...[
              const SizedBox(height: 10),
              const Divider(),

              const Text('Alat'),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Helm safety'),
                  Text('1'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Multimeter'),
                  Text('1'),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(),

              const Text('Tgl dikembalikan : 28/01/2026'),

              const SizedBox(height: 8),
              const Text('Denda terlambat        0'),
              const Text('Denda kerusakan     10000'),
              const Text('Total                      10000'),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Ditolak'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Proses'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
