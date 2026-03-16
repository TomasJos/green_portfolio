import 'package:flutter/material.dart';

class CarbonImpactWidget extends StatelessWidget {
  final double totalCo2Emissions;

  const CarbonImpactWidget({
    super.key,
    required this.totalCo2Emissions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Portfolio Carbon Footprint',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total CO2 Emissions:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${totalCo2Emissions.toStringAsFixed(1)} tons',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: totalCo2Emissions > 10000 ? Colors.red.shade400 : Colors.amber.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (totalCo2Emissions / 20000).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade300,
                color: totalCo2Emissions > 10000 ? Colors.red.shade400 : Colors.amber.shade700,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              totalCo2Emissions > 10000 
                  ? 'High impact! Consider eco-friendly alternatives.'
                  : 'Moderate impact.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
