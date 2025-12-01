import 'package:geolocator/geolocator.dart' as geo;

class LocationService {
  bool gpsOnly = true;

  void setGpsMode(bool value) {
    gpsOnly = value;
  }

  /// Cek apakah GPS aktif
  Future<bool> isLocationServiceEnabled() async {
    return await geo.Geolocator.isLocationServiceEnabled();
  }

  /// Cek permission
  Future<bool> checkPermission() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    return permission == geo.LocationPermission.whileInUse ||
        permission == geo.LocationPermission.always;
  }

  /// Request permission
  Future<bool> requestPermission() async {
    geo.LocationPermission permission =
        await geo.Geolocator.requestPermission();

    return permission == geo.LocationPermission.whileInUse ||
        permission == geo.LocationPermission.always;
  }

  /// Ambil lokasi satu kali — digunakan untuk Eksperimen 1 & 2
  Future<Map<String, dynamic>> getSingleReading() async {
    final position = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: gpsOnly
          ? geo.LocationAccuracy.best
          : geo.LocationAccuracy.low,
    );

    return {
      "lat": position.latitude,
      "lng": position.longitude,
      "accuracy": position.accuracy,
      "timestamp": position.timestamp.toString(),
    };
  }

  /// Live tracking — digunakan untuk Eksperimen 3
  Stream<Map<String, dynamic>> getTrackingStream() {
    return geo.Geolocator.getPositionStream(
      locationSettings: geo.LocationSettings(
        accuracy: gpsOnly
            ? geo.LocationAccuracy.best
            : geo.LocationAccuracy.low,
        distanceFilter: gpsOnly ? 1 : 8, // GPS sensitif, Network lebih longgar
      ),
    ).map((pos) {
      return {
        "lat": pos.latitude,
        "lng": pos.longitude,
        "accuracy": pos.accuracy,
        "speed": pos.speed,
        "timestamp": pos.timestamp.toString(),
      };
    });
  }
}
