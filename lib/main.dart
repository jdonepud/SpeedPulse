import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(const SpeedTestApp());

class SpeedTestApp extends StatefulWidget {
  const SpeedTestApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SpeedTestAppState createState() => _SpeedTestAppState();
}

class _SpeedTestAppState extends State<SpeedTestApp> {
  double _downloadSpeed = 0;
  String _statusMessage = "";

  Future<void> _testDownloadSpeed() async {
    const url =
        'http://speedtest.tele2.net/10MB.zip'; // Use a real test file URL
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(url));
      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytes = response.contentLength ?? 0;
        final seconds = stopwatch.elapsedMilliseconds / 1000;

        setState(() {
          _downloadSpeed = (bytes * 8) / (seconds * 1000 * 1000); // Mbps
          _statusMessage = 'Speed test successful!';
        });
      } else {
        setState(() {
          _statusMessage =
              'Failed to download file. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error downloading file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speed Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _testDownloadSpeed,
                child: const Text('Run Speed Test'),
              ),
              if (_downloadSpeed > 0)
                Text(
                    'Download Speed: ${_downloadSpeed.toStringAsFixed(2)} Mbps'),
              if (_statusMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_statusMessage),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
