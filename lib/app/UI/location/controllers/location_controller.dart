import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/app_pages.dart';

class LocationController extends GetxController {
  // ======================
  // KOORDINAT LOKASI TOKO
  // ======================
  final double storeLat = -7.922240;
  final double storeLng = 112.596601;

  // ======================
  // NAVIGASI HALAMAN
  // ======================
  void goToGpsMap() {
    Get.toNamed(Routes.gps);
  }

  void goToNetworkMap() {
    Get.toNamed(Routes.network);
  }

  // ======================
  // GOOGLE MAPS (AMBIL ALAMAT OTOMATIS)
  // ======================
  Future<void> openGoogleMaps() async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$storeLat,$storeLng',
    );

    if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat membuka Google Maps',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ======================
  // DEFAULT GETX LIFECYCLE
  // ======================
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
