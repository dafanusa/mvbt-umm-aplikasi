import 'package:get/get.dart';

import '../controllers/network_map_controller.dart';

class NetworkMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkMapController>(() => NetworkMapController());
  }
}
