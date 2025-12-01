import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../program/controllers/program_controller.dart';
import '../../jadwal/controllers/jadwal_controller.dart';
import '../../gallery/controllers/gallery_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../gps_location/controllers/gps_map_controller.dart';
import '../../location/controllers/location_controller.dart';
import '../../network_location/controllers/network_map_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProgramController>(() => ProgramController());
    Get.lazyPut<JadwalController>(() => JadwalController());
    Get.lazyPut<GalleryController>(() => GalleryController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<LocationController>(() => LocationController());
    Get.lazyPut<GpsMapController>(() => GpsMapController());
    Get.lazyPut<NetworkMapController>(() => NetworkMapController());
  }
}
