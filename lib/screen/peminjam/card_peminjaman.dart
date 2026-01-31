import 'package:flutter/material.dart';

class PeminjamanPeminjamCard extends StatefulWidget {
  final String nama;
  final String tanggal;
  final String status;

  const PeminjamanPeminjamCard({
    super.key,
    required this.nama,
    required this.tanggal,
    required this.status,
  });

  @override
  State<PeminjamanPeminjamCard> createState() =>
      _PeminjamanPeminjamCardState();
}

class _PeminjamanPeminjamCardState extends State<PeminjamanPeminjamCard> {
  bool isExpanded = false;

  Color _statusColor() {
    switch (widget.status.toLowerCase()) {
      case 'menunggu':
        return Colors.amber;
      case 'dipinjam':
        return Colors.green;
      case 'selesai':
        return Colors.teal;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isExpanded = !isExpanded);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
                      'Diajukan\n${widget.tanggal}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

            /// DETAIL
            if (isExpanded) ...[
              const SizedBox(height: 10),
              const Divider(),

              const Text('Alat'),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Alat'),
                  Text('2'),
                ],
              ),

              if (widget.status.toLowerCase() == 'dipinjam') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Ajukan Pengembalian'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
