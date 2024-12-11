import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String value;

  const HourlyForecastItem(
      {super.key, required this.icon, required this.time, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(time,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade),
            const SizedBox(height: 6),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              value,
            ),
          ],
        ),
      ),
    );
  }
}
