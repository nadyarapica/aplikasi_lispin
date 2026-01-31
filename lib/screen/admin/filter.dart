import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange),
          color: active ? Colors.orange : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.orange,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
