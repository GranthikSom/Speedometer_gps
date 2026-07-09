import 'dart:math' as math;

import 'package:flutter/material.dart';

class OuterArcPainter extends CustomPainter {
  final double speedbreakerFill; // 0.0 – 1.0
  final double nitrousFill;      // 0.0 – 1.0
  final double turboFill;        // 0.0 – 1.0

  OuterArcPainter({
    this.speedbreakerFill = 1.0,
    this.nitrousFill = 0.75,
    this.turboFill = 0.3,
  });

  // Canvas radians — 0 = 3 o'clock, clockwise.
  // Speedbreaker sits at the top (11 o'clock → 2 o'clock).
  static const double sbStart = 4.2;
  static const double sbSweep = 1.6;

  // Nitrous wraps from the right edge of SB around the
  // right / bottom side to the tachometer start (2.2 rad).
  static const double tachoStart = 2.2;
  static const double nitroStart = sbStart + sbSweep; // 5.8
  static const double nitroEnd = tachoStart + 2 * math.pi;

  // Turbo sits right of the bottom opening.
  static const double turboStart = 5.6;
  static const double turboSweep = 0.8;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.45;

    _drawSpeedbreaker(canvas, center, r);
    _drawNitrous(canvas, center, r);
    _drawTurbo(canvas, center, r);
  }

  void _drawSpeedbreaker(Canvas canvas, Offset center, double r) {
    final full = sbSweep * speedbreakerFill;
    if (full <= 0) return;

    final paint = Paint()
      ..color = const Color(0xFFFF8C42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      sbStart,
      full,
      false,
      paint,
    );
  }

  void _drawNitrous(Canvas canvas, Offset center, double r) {
    final full = (nitroEnd - nitroStart) * nitrousFill;
    if (full <= 0) return;

    final paint = Paint()
      ..color = const Color(0xFF7CFC00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      nitroStart,
      full,
      false,
      paint,
    );
  }

  void _drawTurbo(Canvas canvas, Offset center, double r) {
    final segCount = 8;
    final segSweep = turboSweep / segCount;
    final gap = segSweep * 0.25;

    for (int i = 0; i < segCount; i++) {
      final segProgress = (i + 1) / segCount;
      final on = segProgress <= turboFill;

      if (!on) break;

      final start = turboStart + i * (segSweep + gap);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r * 0.82),
        start,
        segSweep,
        false,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.025
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(OuterArcPainter old) =>
      old.speedbreakerFill != speedbreakerFill ||
      old.nitrousFill != nitrousFill ||
      old.turboFill != turboFill;
}
