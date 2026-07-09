import 'package:flutter/material.dart';

class SpeedDisplay extends StatelessWidget {
  final double speed; // km/h

  const SpeedDisplay({super.key, required this.speed});

  @override
  Widget build(BuildContext context) {
    // Convert km/h → mph for the NFS display.
    final mph = speed * 0.621371;
    final display = mph.toStringAsFixed(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8C42),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            display,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'MPH',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
