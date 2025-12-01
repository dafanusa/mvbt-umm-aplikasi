import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:mvbtummaplikasi/app/UI/location/controllers/location_controller.dart';


class LocationView extends GetView<LocationController> {
  final Color maroon;

  const LocationView({super.key, required this.maroon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi'),
        centerTitle: true,
        backgroundColor: maroon, // 🔴 Header merah
        foregroundColor: Colors.white, // 🔴 Biar teksnya kebaca
        elevation: 0, // Opsional
      ),
      body: _buildBody(context),
    );
  }

  Widget _cardInfoLapangan() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Informasi Lapangan MVBT UMM",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Nama: Lapangan MVBT UMM"),
            Text("Alamat: Jl. Tlogomas, Kec.Lowokwaru, Malang"),
            Text("Jam Operasional: 08.00 - 21.00"),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _cardMapLapangan() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(controller.storeLat, controller.storeLng),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.mvbtumm.aplikasi",
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(controller.storeLat, controller.storeLng),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 122, 0, 0),
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih teknologi yang akan anda gunakan untuk melacak posisi di peta secara real-time',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 25),

            _cardInfoLapangan(), // ⬅️ Card informasi toko
            const SizedBox(height: 20),

            _cardMapLapangan(), // ⬅️ Card maps lokasi toko
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: controller.goToGpsMap,
              icon: const Icon(Icons.satellite_alt, size: 28),
              label: const Text(
                'Peta & Data GPS (Akurasi Tinggi)',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 0, 0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: controller.goToNetworkMap,
              icon: const Icon(Icons.wifi, size: 28),
              label: const Text(
                'Peta & Data Jaringan (Akurasi Rendah)',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}