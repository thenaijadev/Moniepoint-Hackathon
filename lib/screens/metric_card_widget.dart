import 'package:flutter/material.dart';
import 'package:monieshop/widgets/text_widget.dart';

class MetricCardWidget extends StatelessWidget {
  const MetricCardWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.details});
  final String title;
  final Icon icon;
  final List<String> details;
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
                icon,
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...details.map((detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: TextWidget(
                    text: detail,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
