import 'package:flutter/material.dart';

class PengembalianCard extends StatefulWidget {
  final String nama;
  final String tanggal;
  final String status;
  final Color statusColor;

  const PengembalianCard({
    super.key,
    required this.nama,
    required this.tanggal,
    required this.status,
    required this.statusColor,
  });

  @override
  State<PengembalianCard> createState() => _PengembalianCardState();
}

class _PengembalianCardState extends State<PengembalianCard> {
  bool isExpanded = false;

  late String currentStatus;
  late Color currentStatusColor;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
    currentStatusColor = widget.statusColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentStatus.toLowerCase() == "kembalikan") {
          setState(() {
            isExpanded = !isExpanded;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentStatus.toLowerCase() == "kembalikan"
                          ? "dipinjam : ${widget.tanggal}"
                          : "kembali : ${widget.tanggal}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: currentStatusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    currentStatus,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            /// DETAIL
            if (isExpanded &&
                currentStatus.toLowerCase() == "kembalikan") ...[
              const SizedBox(height: 12),
              const Divider(),

              const SizedBox(height: 6),
              const Text("Alat"),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Helm safety"),
                  Text("1"),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Multimeter"),
                  Text("1"),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),

              const SizedBox(height: 6),
              const Text("Tgl dikembalikan : 28/01/2026"),

              const SizedBox(height: 12),
              const Text("Denda terlambat        0"),
              const SizedBox(height: 4),
              const Text("Denda kerusakan     10000"),
              const SizedBox(height: 4),
              const Text("Total                      10000"),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// DITOLAK
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        currentStatus = "Ditolak";
                        currentStatusColor = Colors.red;
                        isExpanded = false;
                      });
                    },
                    child: const Text("Ditolak"),
                  ),

                  /// PROSES
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        currentStatus = "Selesai";
                        currentStatusColor = Colors.green;
                        isExpanded = false;
                      });
                    },
                    child: const Text("Proses"),
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
