import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:gps_speedometer/gps_provider.dart';
import 'package:provider/provider.dart' show Consumer;

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

              final speedFontSize = height * 0.28;
              final statFontSize = height * 0.06;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    // TOP BAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: speedProvider.resetStats,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
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
                      ],
                    ),

                    const Spacer(),

                    // SPEED
                    Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            speedProvider.speed.toStringAsFixed(0),
                            style: GoogleFonts.orbitron(
                              fontSize: speedFontSize,
                              fontWeight: FontWeight.bold,
                              color: speedProvider.speed >= 40
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),

                        Text(
                          "KM/H",
                          style: GoogleFonts.rajdhani(
                            fontSize: 28,
                            letterSpacing: 4,
                            color: speedProvider.speed >= 40
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // STATS
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: "MAX",
                            value: speedProvider.maxSpeed.toStringAsFixed(0),
                            fontSize: statFontSize,
                          ),
                        ),

                        Expanded(
                          child: _StatCard(
                            title: "AVG",
                            value: speedProvider.averageSpeed.toStringAsFixed(
                              0,
                            ),
                            fontSize: statFontSize,
                          ),
                        ),

                        Expanded(
                          child: _StatCard(
                            title: "DIST",
                            value:
                                "${(speedProvider.distanceTravelled / 1000).toStringAsFixed(1)} km",
                            fontSize: statFontSize,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
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

  const _StatCard({
    required this.title,
    required this.value,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeedProvider>(
      builder: (context, speedProvider, child) {
        return Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                fontSize: 14,
                letterSpacing: 2,
                color: speedProvider.speed >= 40 ? Colors.red : Colors.white,
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
                  color: speedProvider.speed >= 40 ? Colors.red : Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
