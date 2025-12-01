import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/gps_map_controller.dart';

class GpsMapView extends GetView<GpsMapController> {
  const GpsMapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi MapController
    final mapController = Get.put(
      MapController(),
      tag: 'gps_map_controller_tag',
      permanent: false,
    );

    // Flag untuk mencegah multiple listener
    bool listenerSetup = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta & Data GPS 🛰️'),
        backgroundColor: const Color(0xFF800000), // MAROON
        foregroundColor: Colors.white,
        actions: [
          // Tombol Toggle Tracking
          Obx(() {
            return IconButton(
              onPressed: controller.toggleTracking,
              icon: Icon(
                controller.isTrackingEnabled.value
                    ? Icons.my_location
                    : Icons.location_disabled,
              ),
              tooltip: controller.isTrackingEnabled.value
                  ? 'Nonaktifkan Tracking'
                  : 'Aktifkan Tracking',
            );
          }),
          // Tombol Refresh
          Obx(() {
            return IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.startLocationStream,
              icon: Icon(
                Icons.refresh,
                color: controller.isLoading.value
                    ? const Color(0xFFFFCDD2) // maroon soft
                    : Colors.white,
              ),
              tooltip: 'Muat Ulang Lokasi',
            );
          }),
        ],
      ),
      body: Obx(() {
        final data = controller.currentGpsLocation.value;

        if (!listenerSetup && data != null) {
          listenerSetup = true;
          ever(controller.currentGpsLocation, (LocationData? locationData) {
            if (locationData != null && controller.isTrackingEnabled.value) {
              try {
                final newCenter = LatLng(
                  locationData.latitude,
                  locationData.longitude,
                );
                final currentZoom = mapController.camera.zoom;
                if (currentZoom > 0) {
                  mapController.move(newCenter, currentZoom);
                }
              } catch (e) {
                print('Map move error: $e');
              }
            }
          });
        }

        if (controller.isLoading.value && data == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Memulai pemantauan lokasi GPS...'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildMapContainer(data, mapController),
              const SizedBox(height: 20),
              _buildTrackingStatus(),
              const SizedBox(height: 10),
              _buildDataCard(context, data),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        final data = controller.currentGpsLocation.value;
        if (data == null) return const SizedBox.shrink();

        return FloatingActionButton(
          onPressed: () {
            try {
              final point = LatLng(data.latitude, data.longitude);
              mapController.move(point, 16.0);
              if (!controller.isTrackingEnabled.value) {
                controller.toggleTracking();
              }
            } catch (e) {
              print('FAB error: $e');
            }
          },
          backgroundColor: const Color(0xFF8B0000), // MAROON
          child: const Icon(Icons.center_focus_strong, color: Colors.white),
        );
      }),
    );
  }

  Widget _buildMapContainer(LocationData? data, MapController mapController) {
    if (data == null) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Menunggu data GPS pertama..."),
          ],
        ),
      );
    }

    final point = LatLng(data.latitude, data.longitude);

    return SizedBox(
      height: 350,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: point,
                initialZoom: 16,
                minZoom: 5,
                maxZoom: 18,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onMapReady: () {
                  try {
                    mapController.move(point, 16.0);
                  } catch (e) {
                    print('onMapReady error: $e');
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mvbtumm.aplikasi',
                  maxNativeZoom: 19,
                  maxZoom: 19,
                ),
                Obx(() {
                  final liveData = controller.currentGpsLocation.value;
                  if (liveData == null) return const SizedBox.shrink();

                  final livePoint = LatLng(
                    liveData.latitude,
                    liveData.longitude,
                  );

                  return CircleLayer(
                    circles: [
                      CircleMarker(
                        point: livePoint,
                        radius: liveData.accuracy,
                        useRadiusInMeter: true,
                        color: const Color(0xFF800000).withOpacity(0.2),
                        borderColor: const Color(0xFF800000).withOpacity(0.5),
                        borderStrokeWidth: 2,
                      ),
                    ],
                  );
                }),
                Obx(() {
                  final liveData = controller.currentGpsLocation.value;
                  if (liveData == null) return const SizedBox.shrink();

                  final livePoint = LatLng(
                    liveData.latitude,
                    liveData.longitude,
                  );

                  return MarkerLayer(
                    markers: [
                      Marker(
                        width: 50,
                        height: 50,
                        point: livePoint,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000).withOpacity(0.3),
                              ),
                            ),
                            const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: Colors.black45,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: controller.isTrackingEnabled.value
                        ? Colors.green
                        : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.isTrackingEnabled.value
                            ? Icons.my_location
                            : Icons.location_disabled,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.isTrackingEnabled.value
                            ? 'Tracking ON'
                            : 'Tracking OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStatus() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: controller.isTrackingEnabled.value
              ? Colors.green.shade50
              : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: controller.isTrackingEnabled.value
                ? Colors.green
                : Colors.orange,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              controller.isTrackingEnabled.value
                  ? Icons.check_circle
                  : Icons.info,
              color: controller.isTrackingEnabled.value
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                controller.isTrackingEnabled.value
                    ? 'Mode Tracking Aktif - Peta akan mengikuti pergerakan Anda'
                    : 'Mode Tracking Nonaktif - Geser peta secara manual',
                style: TextStyle(
                  color: controller.isTrackingEnabled.value
                      ? Colors.green.shade900
                      : Colors.orange.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDataCard(BuildContext context, LocationData? data) {
    final bodyStyle = TextStyle(color: Get.theme.textTheme.bodyLarge?.color);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF9A0000), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9A0000).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF800000)),
              const SizedBox(width: 8),
              const Text(
                'Data Lokasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF800000),
                ),
              ),
            ],
          ),
          const Divider(),
          if (data == null)
            Text(
              'Memuat data...',
              style: bodyStyle.copyWith(fontStyle: FontStyle.italic),
            )
          else ...[
            _buildDataRow(
              Icons.pin_drop,
              'Latitude',
              data.latitude.toStringAsFixed(6),
            ),
            _buildDataRow(
              Icons.pin_drop,
              'Longitude',
              data.longitude.toStringAsFixed(6),
            ),
            _buildDataRow(
              Icons.center_focus_strong,
              'Akurasi',
              '${data.accuracy.toStringAsFixed(2)} meter',
              isImportant: true,
              valueColor: data.accuracy < 10
                  ? Colors.green
                  : (data.accuracy < 50 ? Colors.orange : Colors.red),
            ),
            _buildDataRow(Icons.access_time, 'Waktu Update', data.timestamp),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF800000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, size: 16, color: Color(0xFF800000)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lokasi diperbarui otomatis setiap 10 detik',
                      style: bodyStyle.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF800000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataRow(
    IconData icon,
    String label,
    String value, {
    bool isImportant = false,
    Color? valueColor,
  }) {
    final bodyColor = Get.theme.textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF800000)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? bodyColor,
            ),
          ),
        ],
      ),
    );
  }
}