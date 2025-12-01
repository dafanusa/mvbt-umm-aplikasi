import 'package:get/get.dart';

import '../controllers/gps_map_controller.dart';

class GpsMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GpsMapController>(() => GpsMapController());
  }
}