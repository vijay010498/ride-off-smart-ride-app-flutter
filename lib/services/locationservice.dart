import 'dart:async';
import 'package:location/location.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/auth.dart';

class LocationService {
  Location location = Location();
  Timer? timer;
  final AuthService authService = AuthService();

  Future<void> initializeAndStart() async {
    await _requestPermission();
    await _sendLocation();
    _startSendingLocationPeriodically();
  }

  Future<void> _requestPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _sendLocation() async {
    LocationData locationData;

    try {
      locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        await authService.updateUserLocation(
            locationData.longitude!, locationData.latitude!);
      }
    } catch (e) {
      print('Failed to send location: $e');
    }
  }

  void _startSendingLocationPeriodically() {
    timer = Timer.periodic(
        const Duration(seconds: 50), (Timer t) => _sendLocation());
  }

  void dispose() {
    timer?.cancel();
  }
}
