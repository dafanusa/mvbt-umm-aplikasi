import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/jadwal_controller.dart';

class JadwalBinding extends Bindings {
  @override
  void dependencies() {
    // pastikan login controller tersedia
    if (!Get.isRegistered<LoginController>()) {
      Get.lazyPut<LoginController>(() => LoginController());
    }

    Get.lazyPut<JadwalController>(() => JadwalController());
  }
}
