import 'package:get/get.dart';
import '../models/program_model.dart';
import '../services/api_http_service.dart';
import '../services/api_dio_service.dart';

class ProgramController extends GetxController {
  var httpProgramsAsync = <ProgramModel>[].obs;
  var dioProgramsAsync = <ProgramModel>[].obs;
  var httpProgramsCallback = <ProgramModel>[].obs;
  var isLoadingHttp = false.obs;
  var isLoadingDio = false.obs;
  var isLoadingCallback = false.obs;

  final ApiHttpService _httpService = ApiHttpService();
  final ApiDioService _dioService = ApiDioService();
  final RxString apiMode = "http".obs;

  void changeApiMode(String mode) {
    apiMode.value = mode;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProgramsHttpAsync();
    fetchProgramsDioAsync();
    fetchProgramsHttpCallbackChaining();
  }

  Future<void> fetchProgramsHttpAsync() async {
    isLoadingHttp.value = true;
    try {
      httpProgramsAsync.value = await _httpService.fetchProgramsAsync();
      Get.snackbar(
        "Success (HTTP Async)",
        "Memuat ${httpProgramsAsync.length} programs via HTTP.",
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        "Error HTTP (Async)",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHttp.value = false;
    }
  }

  Future<void> fetchProgramsDioAsync() async {
    isLoadingDio.value = true;
    try {
      dioProgramsAsync.value = await _dioService.fetchProgramsAsync();
      Get.snackbar(
        "Success (Dio Async)",
        "Memuat ${dioProgramsAsync.length} programs via DIO.",
        duration: const Duration(seconds: 1),
      );
    } on Exception catch (e) {
      Get.snackbar(
        "Error Dio (Async)",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDio.value = false;
    }
  }

  Future<void> fetchProgramsHttpCallbackChaining() async {
    isLoadingCallback.value = true;
    try {
      httpProgramsCallback.value = await _httpService
          .fetchProgramsCallbackChaining();
      Get.snackbar(
        "Success (Callback)",
        "Memuat ${httpProgramsCallback.length} programs via Callback Chaining.",
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        "Error HTTP (Callback)",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingCallback.value = false;
    }
  }
}
