import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform =
      MethodChannel('com.example.health_integration/health');

  String _healthData = 'Unknown';

  Future<void> getHealthData() async {
    String healthData;
    try {
      final String result = await platform.invokeMethod('getHealthData');
      healthData = 'Health data: $result';
    } on PlatformException catch (e) {
      healthData = "Failed to get health data: '${e.message}'.";
    }

    setState(() {
      _healthData = healthData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Integration"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_healthData),
            ElevatedButton(
              onPressed: getHealthData,
              child: Text('Get Health Data'),
            ),
          ],
        ),
      ),
    );
  }
}
