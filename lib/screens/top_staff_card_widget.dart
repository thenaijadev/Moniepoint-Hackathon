import 'package:flutter/material.dart';

class TopStaffCardWidget extends StatelessWidget {
  const TopStaffCardWidget({super.key, required this.topStaffPerMonth});
  final Map<String, String> topStaffPerMonth;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 32, color: Colors.red[700]),
                const SizedBox(width: 12),
                const Text(
                  'Top Performing Staff',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...topStaffPerMonth.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${entry.key}: Staff #${entry.value}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
