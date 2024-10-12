import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(const SpeedPulseApp());

class SpeedPulseApp extends StatefulWidget {
  const SpeedPulseApp({super.key});

  @override
  _SpeedPulseAppState createState() => _SpeedPulseAppState();
}

class _SpeedPulseAppState extends State<SpeedPulseApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  double _downloadSpeed = 0;
  bool _isTesting = false; // Flag to indicate if a test is running

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // Initialize notification settings
  void _initializeNotifications() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show persistent notification with download speed
  Future<void> _showNotification(double speed) async {
    const androidDetails = AndroidNotificationDetails(
      'speed_test_channel',
      'SpeedPulse Notification',
      channelDescription: 'Speed test notifications',
      importance: Importance.defaultImportance,
      priority: Priority.high,
      ongoing: true, // Makes it persistent
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'SpeedPulse',
      'Download speed: ${speed.toStringAsFixed(1)} Mbps',
      notificationDetails,
    );
  }

  // Real speed test logic: download a test file and calculate download speed
  Future<void> _startSpeedTest() async {
    if (_isTesting) return; // Prevent multiple tests at the same time
    setState(() {
      _isTesting = true;
      _downloadSpeed = 0;
    });

    const url =
        'http://ipv4.download.thinkbroadband.com/10MB.zip'; // Example test file
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(url));
      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytes = response.contentLength ?? 0;
        final seconds = stopwatch.elapsedMilliseconds / 1000;

        setState(() {
          _downloadSpeed =
              (bytes * 8) / (seconds * 1000000); // Convert bytes to Mbps
        });

        // Show notification with real speed
        await _showNotification(_downloadSpeed);
      }
    } catch (e) {
      setState(() {
        _downloadSpeed = 0;
      });
      print('Error: $e');
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  void dispose() {
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
                percent: _downloadSpeed /
                    100, // Display speed as a percentage of 100 Mbps
                center: Text(
                  "${_downloadSpeed.toStringAsFixed(1)} Mbps",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                footer: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Testing Download Speed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
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
