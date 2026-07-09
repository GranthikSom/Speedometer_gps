import 'package:flutter/material.dart';
import 'package:gps_speedometer/gps_provider.dart';
import 'package:gps_speedometer/widgets/gauge_needle.dart';
import 'package:gps_speedometer/widgets/gear_indicator.dart';
import 'package:gps_speedometer/widgets/outer_arc_painter.dart';
import 'package:gps_speedometer/widgets/speed_display.dart';
import 'package:gps_speedometer/widgets/tachometer_painter.dart';
import 'package:provider/provider.dart';

class NfsSpeedometer extends StatefulWidget {
  const NfsSpeedometer({super.key});

  @override
  State<NfsSpeedometer> createState() => _NfsSpeedometerState();
}

class _NfsSpeedometerState extends State<NfsSpeedometer> {
  int _prevGear = 1;
  bool _shiftingUp = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeedProvider>(
      builder: (context, provider, _) {
        final currentGear = gearForSpeed(provider.speed);
        if (currentGear != _prevGear) {
          _shiftingUp = currentGear > _prevGear;
          _prevGear = currentGear;
        }

        return SafeArea(
          child: Container(
            color: const Color(0xFF8B8B8B),
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gaugeSize = constraints.maxHeight * 0.88;
                return Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: _leftPanel(provider),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: gaugeSize,
                          height: gaugeSize,
                          child: _gauge(provider, gaugeSize),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 160,
                      child: _rightPanel(provider),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _leftPanel(SpeedProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ctrlBtn(Icons.refresh, 'RESET', provider.resetStats),
        const SizedBox(height: 14),
        _ctrlBtn(
          provider.isPaused ? Icons.play_arrow : Icons.pause,
          provider.isPaused ? 'RESUME' : 'PAUSE',
          provider.togglePause,
        ),
      ],
    );
  }

  Widget _ctrlBtn(IconData icon, String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 50),
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: const Color(0xFFFF8C42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
        ),
      ),
    );
  }

  Widget _rightPanel(SpeedProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _statCard('MAX', provider.maxSpeed.toStringAsFixed(0)),
        const SizedBox(height: 10),
        _statCard('AVG', provider.averageSpeed.toStringAsFixed(0)),
        const SizedBox(height: 10),
        _statCard(
          'DIST',
          '${(provider.distanceTravelled / 1000).toStringAsFixed(1)} km',
        ),
        const SizedBox(height: 10),
        _statCard('TIME', provider.formattedRideTime),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 3,
              color: Color(0x80FF8C42),
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _gauge(SpeedProvider provider, double size) {
    final rpm = (provider.speed / 200.0) * 8000.0;
    final needleProgress = (rpm / 8000.0).clamp(0.0, 1.0);
    final targetAngle =
        TachometerPainter.startAngle +
        TachometerPainter.sweepAngle * needleProgress;

    return Stack(
      alignment: Alignment.center,
      children: [
        RepaintBoundary(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: TachometerPainter.startAngle,
              end: targetAngle,
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, angle, _) {
              final animProgress =
                  ((angle - TachometerPainter.startAngle) /
                          TachometerPainter.sweepAngle)
                      .clamp(0.0, 1.0);
              final animRpm = animProgress * 8000.0;

              return CustomPaint(
                size: Size(size, size),
                painter: CombinedGaugePainter(
                  rpmValue: animRpm,
                  needleAngle: angle,
                  speedbreakerFill: 1.0,
                  nitrousFill: 0.75,
                  turboFill: 0.3,
                ),
              );
            },
          ),
        ),
        _overlay(provider, size),
      ],
    );
  }

  Widget _overlay(SpeedProvider provider, double size) {
    return Stack(
      children: [
        // Gear indicator at upper-center of the display area.
        Positioned(
          top: size * 0.60,
          left: 0,
          right: 0,
          child: Center(
            child: GearIndicator(
              gear: _prevGear,
              shiftingUp: _shiftingUp,
            ),
          ),
        ),
        // Speed display at bottom center.
        Positioned(
          bottom: size * 0.08,
          left: 0,
          right: 0,
          child: Center(
            child: SpeedDisplay(speed: provider.speed),
          ),
        ),
        // Decorative icons.
        Positioned(
          bottom: size * 0.02,
          left: size * 0.05,
          child: Icon(Icons.science,
              color: const Color(0xFF7CFC00), size: size * 0.06),
        ),
        Positioned(
          top: size * 0.02,
          right: size * 0.05,
          child: Icon(Icons.timer,
              color: Colors.white54, size: size * 0.06),
        ),
      ],
    );
  }
}

/// Draws the outer arcs, tachometer, and needle in a single pass.
class CombinedGaugePainter extends CustomPainter {
  final double rpmValue;
  final double needleAngle;
  final double speedbreakerFill;
  final double nitrousFill;
  final double turboFill;

  CombinedGaugePainter({
    required this.rpmValue,
    required this.needleAngle,
    this.speedbreakerFill = 1.0,
    this.nitrousFill = 0.75,
    this.turboFill = 0.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outer = OuterArcPainter(
      speedbreakerFill: speedbreakerFill,
      nitrousFill: nitrousFill,
      turboFill: turboFill,
    );
    outer.paint(canvas, size);

    final tacho = TachometerPainter(rpmValue: rpmValue);
    tacho.paint(canvas, size);

    final needle = GaugeNeedlePainter(angleRad: needleAngle);
    needle.paint(canvas, size);
  }

  @override
  bool shouldRepaint(CombinedGaugePainter old) =>
      old.rpmValue != rpmValue ||
      old.needleAngle != needleAngle ||
      old.speedbreakerFill != speedbreakerFill ||
      old.nitrousFill != nitrousFill ||
      old.turboFill != turboFill;
}
