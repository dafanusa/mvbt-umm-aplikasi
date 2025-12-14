import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/network_map_controller.dart';

class NetworkMapView extends GetView<NetworkMapController> {
  const NetworkMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta & Data Jaringan 📶"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          Obx(() {
            return IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.startNetworkLocationStream,
              icon: Icon(
                Icons.refresh,
                color: controller.isLoading.value
                    ? Colors.orange.shade200
                    : Colors.white,
              ),
            );
          }),
        ],
      ),

      body: Obx(() {
        final data = controller.currentNetworkLocation.value;

        /// CONDITION: FIRST LOAD
        if (controller.isLoading.value && data == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.orange),
                SizedBox(height: 10),
                Text("Mengambil lokasi jaringan..."),
              ],
            ),
          );
        }

        /// PAGE CONTENT
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMap(data),
              const SizedBox(height: 20),
              _buildDataCard(context, data),
            ],
          ),
        );
      }),
    );
  }

  // MAP WIDGET
  Widget _buildMap(NetworkLocationData? data) {
    if (data == null) {
      return SizedBox(
        height: 300,
        child: Center(child: Text("Menunggu lokasi pertama...")),
      );
    }

    final point = LatLng(data.latitude, data.longitude);

    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 16,
            // real-time update
            onMapReady: () {},
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.mvbtumm.aplikasi",
            ),
            Obx(() {
              final live = controller.currentNetworkLocation.value;
              if (live == null) return MarkerLayer(markers: []);

              return MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(live.latitude, live.longitude),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.orange,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // DATA CARD
  Widget _buildDataCard(BuildContext context, NetworkLocationData? d) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: d == null
          ? const Text("Memuat data...")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data Lokasi Jaringan",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const Divider(),

                _row("Latitude", d.latitude.toStringAsFixed(6)),
                _row("Longitude", d.longitude.toStringAsFixed(6)),

                _row(
                  "Accuracy (m)",
                  d.accuracy.toStringAsFixed(1),
                  isImportant: true,
                  color: d.accuracy < 50
                      ? Colors.green
                      : (d.accuracy < 150 ? Colors.orange : Colors.red),
                ),

                _row("Timestamp", d.timestamp),

                const SizedBox(height: 8),
                const Text(
                  "Diperbarui setiap 20 detik.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool isImportant = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
