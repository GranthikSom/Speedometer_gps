import 'package:flutter/material.dart';
import 'package:gps_speedometer/gps_provider.dart';
import 'package:gps_speedometer/speedometer.dart' show SpeedometerPage;
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final gpsProvider = SpeedProvider();

            gpsProvider.startTracking();

            return gpsProvider;
          },
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedometer',
      debugShowCheckedModeBanner: false,

      home: const Scaffold(
        backgroundColor: Colors.black,
        body: SpeedometerPage(),
      ),
    );
  }
}
