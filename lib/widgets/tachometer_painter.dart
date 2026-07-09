import 'dart:math' as math;

import 'package:flutter/material.dart';

class TachometerPainter extends CustomPainter {
  final double rpmValue; // 0 – 8000

  TachometerPainter({required this.rpmValue});

  // Arc angles (canvas radians, 0 = 3 o'clock, clockwise).
  static const double startAngle = 2.2;
  static const double sweepAngle = 4.6;
  static const double endAngle = startAngle + sweepAngle; // 6.8

  // RPM thresholds for colored zones.
  static const double yellowStart = 5500;
  static const double redStart = 6500;
  static const double maxRpm = 8000;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.34;
    final stroke = r * 0.18;

    // Background arc.
    final bgPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Yellow zone.
    final yStart = startAngle + sweepAngle * (yellowStart / maxRpm);
    final ySweep = sweepAngle * ((redStart - yellowStart) / maxRpm);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      yStart,
      ySweep,
      false,
      Paint()
        ..color = const Color(0xFFFFB347)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    // Red zone.
    final rStart = startAngle + sweepAngle * (redStart / maxRpm);
    final rSweep = sweepAngle * ((maxRpm - redStart) / maxRpm);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      rStart,
      rSweep,
      false,
      Paint()
        ..color = const Color(0xFFFF3B30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    // Dark inner face.
    canvas.drawCircle(
      center,
      r - stroke / 2 - 2,
      Paint()..color = const Color(0xFF0D0D0D),
    );

    // Tick marks.
    for (int rpm = 0; rpm <= 8000; rpm += 500) {
      final a = startAngle + sweepAngle * (rpm / maxRpm);
      final isMajor = rpm % 1000 == 0;
      final len = isMajor ? r * 0.12 : r * 0.06;
      final iR = r - stroke / 2 - 2;
      final oR = iR - len;

      canvas.drawLine(
        Offset(center.dx + math.cos(a) * iR,
            center.dy + math.sin(a) * iR),
        Offset(center.dx + math.cos(a) * oR,
            center.dy + math.sin(a) * oR),
        Paint()
          ..color = isMajor ? Colors.white70 : Colors.white30
          ..strokeWidth = isMajor ? 2.5 : 1.0,
      );
    }

    // Numeric labels (every 1000 RPM).
    for (int rpm = 0; rpm <= 8000; rpm += 1000) {
      final a = startAngle + sweepAngle * (rpm / maxRpm);
      final lr = r - stroke / 2 - r * 0.20;
      final pos = Offset(
        center.dx + math.cos(a) * lr,
        center.dy + math.sin(a) * lr,
      );
      final label = (rpm ~/ 1000).toString();
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(TachometerPainter old) => old.rpmValue != rpmValue;
}
