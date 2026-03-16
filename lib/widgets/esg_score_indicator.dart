import 'package:flutter/material.dart';

class EsgScoreIndicator extends StatelessWidget {
  final int esgScore;
  final double size;

  const EsgScoreIndicator({
    super.key,
    required this.esgScore,
    this.size = 60.0,
  });

  Color _getIndicatorColor() {
    if (esgScore >= 70) return Colors.green.shade600;
    if (esgScore >= 40) return Colors.amber.shade700;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _getIndicatorColor(),
          width: 4,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              esgScore.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size * 0.35,
                color: _getIndicatorColor(),
              ),
            ),
            Text(
              'ESG',
              style: TextStyle(
                fontSize: size * 0.18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
