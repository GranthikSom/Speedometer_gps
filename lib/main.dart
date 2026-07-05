import 'package:flutter/material.dart';
import 'package:gps_speedometer/speedometer.dart' show SpeedometerPage;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Speedometer', home: const SpeedometerPage());
  }
}
