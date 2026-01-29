import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE082),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          /// ICON POJOK KIRI ATAS (DINAMIS)
          Positioned(
            top: 14,
            left: 14,
            child: Icon(
              icon,
              size: 22,
            ),
          ),

          /// ANGKA & LABEL DI TENGAH
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
