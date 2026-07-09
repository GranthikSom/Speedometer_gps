import 'dart:math' as math;

import 'package:flutter/material.dart';

class GaugeNeedlePainter extends CustomPainter {
  final double angleRad; // absolute canvas angle for the needle tip

  GaugeNeedlePainter({required this.angleRad});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.34;
    final needleLen = r * 1.02;

    final tip = Offset(
      center.dx + math.cos(angleRad) * needleLen,
      center.dy + math.sin(angleRad) * needleLen,
    );

    // Glow
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = const Color(0xFFFF6B35).withAlpha(50)
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );

    // Needle body
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = const Color(0xFFFF6B35)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Counter-weight stub
    final cwLen = r * 0.12;
    canvas.drawLine(
      center,
      Offset(
        center.dx - math.cos(angleRad) * cwLen,
        center.dy - math.sin(angleRad) * cwLen,
      ),
      Paint()
        ..color = const Color(0xFFFF6B35).withAlpha(100)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Pivot
    canvas.drawCircle(center, 16, Paint()..color = const Color(0xFF1A1A2E));
    canvas.drawCircle(
      center,
      16,
      Paint()
        ..color = const Color(0xFFFF6B35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(center, 4, Paint()..color = const Color(0xFFFF6B35));
  }

  @override
  bool shouldRepaint(GaugeNeedlePainter old) => old.angleRad != angleRad;
}
