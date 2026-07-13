import 'package:flutter/material.dart';

int gearForSpeed(double speedKmh) {
  if (speedKmh < 20) return 1;
  if (speedKmh < 40) return 2;
  if (speedKmh < 60) return 3;
  if (speedKmh < 90) return 4;
  if (speedKmh < 120) return 5;
  if (speedKmh < 160) return 6;
  return 1;
}

class GearIndicator extends StatelessWidget {
  final int gear;
  final bool shiftingUp;

  const GearIndicator({
    super.key,
    required this.gear,
    required this.shiftingUp,
  });

  @override
  Widget build(BuildContext context) {
    final arrow = shiftingUp ? '\u25B2' : '\u25BC';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF8C42),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            arrow,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$gear',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
