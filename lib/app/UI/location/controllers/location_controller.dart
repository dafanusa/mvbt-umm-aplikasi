import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LocationController extends GetxController {
  final double storeLat = -7.922240;
  final double storeLng = 112.596601;

  void goToGpsMap() {
    Get.toNamed(Routes.gps);
  }

  // Fungsi navigasi ke halaman Peta Jaringan
  void goToNetworkMap() {
    Get.toNamed(Routes.network);
  }

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