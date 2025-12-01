import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

// --- MODEL DATA LOKASI ---
class LocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final String timestamp; // hanya jam
  final String method;
  final Color color;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    required this.method,
    required this.color,
  });
}

class GpsMapController extends GetxController {
  final currentGpsLocation = Rxn<LocationData>();
  final isLoading = true.obs;
  final isTrackingEnabled = true.obs;

  StreamSubscription<Position>? _gpsSubscription;
  final Duration _updateInterval = const Duration(
    seconds: 15,
  ); // interval accuracy
  final String method = 'GPS (Akurasi Terbaik)';

  bool _isInitialized = false;
  DateTime _lastAccuracyUpdate = DateTime.now().subtract(
    const Duration(seconds: 15),
  );

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_isInitialized) {
        _isInitialized = true;
        startLocationStream();
      }
    });
  }

  @override
  void onClose() {
    _gpsSubscription?.cancel();
    _gpsSubscription = null;
    _isInitialized = false;
    super.onClose();
  }

  void toggleTracking() {
    isTrackingEnabled.value = !isTrackingEnabled.value;

    Get.snackbar(
      'Mode Tracking',
      isTrackingEnabled.value
          ? 'Tracking diaktifkan - Peta akan mengikuti lokasi Anda'
          : 'Tracking dinonaktifkan - Anda dapat menggeser peta secara manual',
      backgroundColor: isTrackingEnabled.value ? Colors.green : Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }

  Future<void> startLocationStream() async {
    if (!_isInitialized) return;

    try {
      isLoading(true);
      await _gpsSubscription?.cancel();
      _gpsSubscription = null;

      if (!await _handleLocationPermission()) {
        isLoading(false);
        return;
      }

      Get.snackbar(
        'Status',
        'Memulai pemantauan GPS...',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );

      LocationSettings locationSettings;

      if (Platform.isAndroid) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1, // update tiap meter
          intervalDuration: const Duration(milliseconds: 500), // realtime
          forceLocationManager: false,
        );
      } else if (Platform.isIOS || Platform.isMacOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.fitness,
          distanceFilter: 1,
          pauseLocationUpdatesAutomatically: true,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
        );
      }

      _gpsSubscription =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (Position position) {
              if (!_isInitialized) return;

              // Update posisi real-time
              currentGpsLocation.value = _mapPositionToLocationData(position);

              // Update accuracy / tambahan hanya tiap interval
              if (DateTime.now().difference(_lastAccuracyUpdate) >=
                  _updateInterval) {
                _lastAccuracyUpdate = DateTime.now();
                // Bisa tambah log, update UI, dsb
                print(
                  "Update accuracy: ${position.accuracy} at ${currentGpsLocation.value?.timestamp}",
                );
              }

              isLoading(false);
            },
            onError: (error) {
              print('GPS Stream Error: $error');
              Get.snackbar(
                'Error GPS',
                'Gagal mendapatkan lokasi. Coba aktifkan GPS.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.all(10),
              );
              isLoading(false);
            },
            cancelOnError: false,
          );
    } catch (e) {
      print('Error starting location stream: $e');
      Get.snackbar(
        'Error',
        'Gagal memulai GPS: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
      );
      isLoading(false);
    }
  }

  Future<bool> _handleLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'GPS Nonaktif',
          'Aktifkan GPS di pengaturan perangkat Anda.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(10),
        );
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Izin Ditolak',
            'Aplikasi memerlukan izin lokasi untuk berfungsi.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Izin Permanen Ditolak',
          'Buka Pengaturan > Aplikasi > Izin untuk mengaktifkan lokasi.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(10),
        );
        return false;
      }

      return true;
    } catch (e) {
      print('Permission error: $e');
      return false;
    }
  }

  LocationData _mapPositionToLocationData(Position position) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: DateTime.now().toLocal().toIso8601String().substring(11, 19),
      method: method,
      color: Colors.blue,
    );
  }
}