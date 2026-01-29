import 'package:flutter/material.dart';


class ActivityCard extends StatelessWidget {
  final String title;
  final String user;
  final String unit;
  final String date;

  const ActivityCard({
    super.key,
    required this.title,
    required this.user,
    required this.unit,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          // ICON
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange),
            ),
            child: const Icon(Icons.access_time, size: 18),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // UNIT & DATE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                unit,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
