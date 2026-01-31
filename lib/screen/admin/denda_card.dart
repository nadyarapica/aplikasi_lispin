import 'package:aplikasi_lispin/screen/admin/tambah_denda_dialog.dart';
import 'package:flutter/material.dart';

class DendaCard extends StatelessWidget {
  final String title;
  final int nominal;

  const DendaCard({
    super.key,
    required this.title,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9800);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Rp. $nominal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () {
              showDendaDialog(
                context: context,
                mode: "edit",
                initialName: title,
                initialNominal: nominal.toString(),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete, size: 18),
            onPressed: () {
              showDendaDialog(
                context: context,
                mode: "delete", initialName: '', initialNominal: '',
              );
            },
          ),
        ],
      ),
    );
  }
}
