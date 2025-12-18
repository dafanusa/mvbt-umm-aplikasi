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
        title: const Text(
          'Lokasi',
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5, 
          ),
        ),
        centerTitle: true,
        backgroundColor: maroon,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            Text("Alamat: Jl. Tlogomas, Kec. Lowokwaru, Malang"),
            Text("Jam Operasional: 08.00 - 21.00"),
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
        height: 220,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(controller.storeLat, controller.storeLng),
            initialZoom: 15,

            // Klik map → Google Maps
            onTap: (_, __) => controller.openGoogleMaps(),
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
                  child: GestureDetector(
                    onTap: controller.openGoogleMaps,
                    child: const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 122, 0, 0),
                      size: 40,
                    ),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ======================
            // HEADER SECTION
            // ======================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: maroon.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(Icons.place, color: Color.fromARGB(255, 122, 0, 0)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Lokasi Lapangan MVBT UMM',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ======================
            // INFO CARD
            // ======================
            _cardInfoLapangan(),

            const SizedBox(height: 18),

            // ======================
            // MAP TITLE
            // ======================
            Row(
              children: const [
                Icon(Icons.map, size: 20),
                SizedBox(width: 8),
                Text(
                  'Peta Lokasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ======================
            // MAP CARD (LEBIH TINGGI)
            // ======================
            SizedBox(height: 280, child: _cardMapLapangan()),

            const SizedBox(height: 10),

            // ======================
            // HINT TEXT
            // ======================
            const Text(
              'lokasi Lapangan MVBT bisa diakses dibawah ini!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // ======================
            // GOOGLE MAPS BUTTON
            // ======================
            ElevatedButton.icon(
              onPressed: controller.openGoogleMaps,
              icon: const Icon(Icons.directions),
              label: const Text(
                'Buka di Google Maps',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: maroon,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
