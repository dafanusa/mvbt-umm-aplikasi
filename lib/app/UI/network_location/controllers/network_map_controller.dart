import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class NetworkLocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final String timestamp;
  final String method;
  final Color color;

  NetworkLocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    required this.method,
    required this.color,
  });
}

class NetworkMapController extends GetxController {
  /// DATA REALTIME
  final currentNetworkLocation = Rxn<NetworkLocationData>();

  /// LOADING STATE
  final isLoading = true.obs;

  /// STREAM SUBSCRIPTION
  StreamSubscription<Position>? _networkSubscription;

  /// UPDATE INTERVAL NETWORK PROVIDER
  final Duration _updateInterval = const Duration(seconds: 20);

  /// METHOD IDENTIFIER
  final String method = 'Network Provider (Cell/WiFi)';

  @override
  void onInit() {
    super.onInit();
    startNetworkLocationStream();
  }

  @override
  void onClose() {
    _networkSubscription?.cancel();
    super.onClose();
  }

  // =======================================================================
  // START STREAM (LIVE NETWORK LOCATION)
  // =======================================================================
  Future<void> startNetworkLocationStream() async {
    isLoading(true);

    if (!await _handleLocationPermission()) {
      isLoading(false);
      return;
    }

    // Cancel jika ada stream sebelumnya
    _networkSubscription?.cancel();

    Get.snackbar(
      'Status',
      'Memulai pemantauan lokasi jaringan...',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 0,
    );

    /// Platform specific
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 0,
        intervalDuration: _updateInterval,
        forceLocationManager: false,
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 0,
      );
    }

    /// LISTEN STREAM (REAL-TIME)
    _networkSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position pos) {
            currentNetworkLocation.value = _mapPositionToModel(pos);
            isLoading(false);
          },
          onError: (e) {
            isLoading(false);
            Get.snackbar(
              "Error",
              "Gagal mendapatkan lokasi jaringan.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          },
        );
  }

  // =======================================================================
  // PERMISSION HANDLER
  // =======================================================================
  Future<bool> _handleLocationPermission() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      Get.snackbar(
        "Error",
        "Layanan lokasi dimatikan.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied) {
        Get.snackbar(
          "Error",
          "Izin lokasi ditolak.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    if (p == LocationPermission.deniedForever) {
      Get.snackbar(
        "Error",
        "Izin lokasi ditolak permanen. Buka pengaturan aplikasi.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return false;
    }

    return true;
  }

  // =======================================================================
  // CONVERT MODEL
  // =======================================================================
  NetworkLocationData _mapPositionToModel(Position pos) {
    return NetworkLocationData(
      latitude: pos.latitude,
      longitude: pos.longitude,
      accuracy: pos.accuracy,
      timestamp: DateTime.now().toLocal().toIso8601String().substring(11, 19),
      method: method,
      color: Colors.orange,
    );
  }
}
