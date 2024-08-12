import 'package:flutter/services.dart';

const platform = MethodChannel('com.example.health_integration/health');

class HealthKitHelper {
  Future<void> getSteps() async {
    try {
      final String result = await platform.invokeMethod('getSteps');
      print("STEPS: $result");
    } on PlatformException catch (e) {
      "Failed to get health data: '${e.message}'.";
    }
  }

  Future<void> getActiveCaloriesBurned() async {
    try {
      final String result =
          await platform.invokeMethod('getActiveCaloriesBurned');
      print("ACTIVE CALORIES: $result");
    } on PlatformException catch (e) {
      "Failed to get health data: '${e.message}'.";
    }
  }

  Future<void> getRestCaloriesBurned() async {
    try {
      final String result =
          await platform.invokeMethod('getRestingCaloriesBurned');
      print("REST CALORIES: $result");
    } on PlatformException catch (e) {
      "Failed to get health data: '${e.message}'.";
    }
  }

  Future<void> getHeartRate() async {
    try {
      final String result = await platform.invokeMethod('getHeartRate');
      print("HEART RATE: $result");
    } on PlatformException catch (e) {
      "Failed to get health data: '${e.message}'.";
    }
  }
}
