import 'package:flutter/material.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({Key? key}) : super(key: key);

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'peminjaman',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'search',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'daftar peminjaman',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildPeminjamanItem(
                    index: 0,
                    nama: 'Egi dwi saputri',
                    tanggal: '22/01/2026',
                    statusColor: Colors.yellow.shade700,
                    statusText: 'Menunggu',
                    alat: 'Helm safety',
                    barang: 'Multimeter',
                    jumlah: '1',
                    tanggalPinjam: '20/01/2026',
                  ),
                  const SizedBox(height: 12),
                  _buildPeminjamanItem(
                    index: 1,
                    nama: 'Melati tiara permata',
                    tanggal: '22/01/2026',
                    statusColor: Colors.green,
                    statusText: 'Dipinjam',
                    alat: '',
                    barang: '',
                    jumlah: '',
                    tanggalPinjam: '20/01/2026',
                  ),
                  const SizedBox(height: 12),
                  _buildPeminjamanItem(
                    index: 2,
                    nama: 'chella robiatul',
                    tanggal: '22/01/2026',
                    statusColor: Colors.red,
                    statusText: '',
                    alat: '',
                    barang: '',
                    jumlah: '',
                    tanggalPinjam: '22/01/2026',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeminjamanItem({
    required int index,
    required String nama,
    required String tanggal,
    required Color statusColor,
    required String statusText,
    required String alat,
    required String barang,
    required String jumlah,
    required String tanggalPinjam,
  }) {
    bool isExpanded = expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (expandedIndex == index) {
            expandedIndex = null;
          } else {
            expandedIndex = index;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tanggal,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isExpanded)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade300, height: 1),
              const SizedBox(height: 12),
              _buildDetailRow('Alat', alat),
              const SizedBox(height: 8),
              _buildDetailRow('Barang', barang),
              const SizedBox(height: 8),
              _buildDetailRow('Jumlah', jumlah),
              const SizedBox(height: 8),
              _buildDetailRow('Tanggal', tanggalPinjam),
              const SizedBox(height: 16),
              _buildDetailRow('Status', ''),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        if (value.isNotEmpty) ...[
          Text(
            ': ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ] else ...[
          Text(
            ':',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ],
    );
  }
}