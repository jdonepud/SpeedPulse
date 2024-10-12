import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

void main() => runApp(const SpeedPulseApp());

class SpeedPulseApp extends StatefulWidget {
  const SpeedPulseApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SpeedPulseAppState createState() => _SpeedPulseAppState();
}

class _SpeedPulseAppState extends State<SpeedPulseApp> {
  // Notification setup
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  double _downloadSpeed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // Initialize notifications when the app starts
  }

  // Initialize the notification plugin
  void _initializeNotifications() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a persistent notification with the current speed

  // Simulate a speed test for UI purposes (replace this with actual speed test logic)
  void _startSpeedTest() {
    _downloadSpeed = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _downloadSpeed += 2; // Increment speed
        if (_downloadSpeed >= 100) {
          _timer?.cancel();
        }
      });

      // Update notification with the current speed
      _showNotification(_downloadSpeed);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SpeedPulse'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 13.0,
                animation: true,
                percent: _downloadSpeed / 100,
                center: Text(
                  "${_downloadSpeed.toStringAsFixed(1)} Mbps",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Testing Download Speed",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.blueAccent,
                backgroundColor: Colors.grey[200]!,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _startSpeedTest,
                child: const Text("Start Speed Test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _showNotification {
  _showNotification(Object speed);
}
