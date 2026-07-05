import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gps_speedometer/gps_provider.dart';
import 'package:provider/provider.dart';

class SpeedometerPage extends StatelessWidget {
  const SpeedometerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeedProvider>(
      builder: (context, speedProvider, child) {
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;

              final speedFontSize = height * 0.60;
              final statFontSize = height * 0.06;

              final isOverspeed = speedProvider.speed >= 40;
              final textColor = isOverspeed ? Colors.red : Colors.white;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // TOP BAR
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: speedProvider.resetStats,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text("RESET"),
                            ),

                            const SizedBox(width: 8),

                            ElevatedButton.icon(
                              onPressed: speedProvider.togglePause,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(
                                speedProvider.isPaused
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                size: 18,
                              ),
                              label: Text(
                                speedProvider.isPaused ? "RESUME" : "PAUSE",
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: _StatCard(
                                title: "MAX",
                                value: speedProvider.maxSpeed.toStringAsFixed(
                                  0,
                                ),
                                fontSize: statFontSize,
                                color: textColor,
                              ),
                            ),

                            Container(
                              child: _StatCard(
                                title: "AVG",
                                value: speedProvider.averageSpeed
                                    .toStringAsFixed(0),
                                fontSize: statFontSize,
                                color: textColor,
                              ),
                            ),

                            Container(
                              child: _StatCard(
                                title: "DIST",
                                value:
                                    "${(speedProvider.distanceTravelled / 1000).toStringAsFixed(1)} km",
                                fontSize: statFontSize * 0.75,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // STATS
                    const Spacer(),

                    // SPEED
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        speedProvider.speed.toStringAsFixed(0),
                        style: GoogleFonts.orbitron(
                          fontSize: speedFontSize,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "KM/H",
                      style: GoogleFonts.rajdhani(
                        fontSize: 28,
                        letterSpacing: 4,
                        color: textColor,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
            fontSize: 24,
            letterSpacing: 2,
            color: color,
          ),
        ),

        const SizedBox(height: 6),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
