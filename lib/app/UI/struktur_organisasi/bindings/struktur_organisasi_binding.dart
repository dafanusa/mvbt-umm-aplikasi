import 'package:get/get.dart';
import '../controllers/struktur_organisasi_controller.dart';

class StrukturOrganisasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StrukturOrganisasiController>(() => StrukturOrganisasiController());
  }
}
