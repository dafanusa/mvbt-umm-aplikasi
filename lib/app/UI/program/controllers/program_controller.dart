import 'dart:async';
import 'package:get/get.dart';
import '../../../models/program_model.dart';
import '../../../../services/api_http_service.dart';
import '../../../../services/api_dio_service.dart';

class ProgramController extends GetxController {

  var httpProgramsAsync = <ProgramModel>[].obs;
  var dioProgramsAsync = <ProgramModel>[].obs;
  var httpProgramsCallback = <ProgramModel>[].obs;
  var isLoadingHttp = false.obs;
  var isLoadingDio = false.obs;
  var isLoadingCallback = false.obs;
  var statusCode = "".obs;
  var statusMessage = "".obs;
  var responseLog = "".obs;

  final ApiHttpService _httpService = ApiHttpService();
  final ApiDioService _dioService = ApiDioService();

  final RxString apiMode = "http".obs; 

  void changeApiMode(String mode) {
    apiMode.value = mode;
  }

  @override
  void onInit() {
    super.onInit();
    fetchPrograms();
  }

  /// PANGGILAN UTAMA
  Future<void> fetchPrograms() async {
    if (apiMode.value == "http") {
      await fetchProgramsHttpAsync();
    } else if (apiMode.value == "dio") {
      await fetchProgramsDioAsync();
    } else if (apiMode.value == "callback") {
      await fetchProgramsHttpCallbackChaining();
    }
  }

  /// HTTP ASYNC
  Future<void> fetchProgramsHttpAsync() async {
    isLoadingHttp.value = true;
    try {
      final result = await _httpService.fetchProgramsWithStatus().timeout(
        const Duration(seconds: 5),
      );

      httpProgramsAsync.value = result['data'];
      statusCode.value = result['statusCode'].toString();
      responseLog.value = result['raw'] ?? "";

      if (result['statusCode'] == 200) {
        statusMessage.value = "✅ HTTP Success";
      } else {
        statusMessage.value = "❌ HTTP Error (${result['statusCode']})";
        Get.snackbar(
          "HTTP Error",
          "Status: ${result['statusCode']}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on TimeoutException {
      statusMessage.value = "❌ HTTP Timeout";
      responseLog.value =
          "❌ HTTP Timeout: Server tidak merespon dalam 5 detik.";
      Get.snackbar(
        "Timeout (HTTP)",
        "Server tidak merespon dalam 5 detik.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      statusMessage.value = "❌ HTTP Exception: $e";
      responseLog.value = "❌ HTTP Exception: $e";
      Get.snackbar(
        "Error HTTP (Async)",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHttp.value = false;
    }
  }

  /// DIO ASYNC
  Future<void> fetchProgramsDioAsync() async {
    isLoadingDio.value = true;
    try {
      final result = await _dioService.fetchProgramsWithStatus().timeout(
        const Duration(seconds: 5),
      );

      dioProgramsAsync.value = result['data'];
      statusCode.value = result['statusCode'].toString();
      responseLog.value = result['raw'] ?? "";

      if (result['statusCode'] == 200) {
        statusMessage.value = "✅ Dio Success";
      } else {
        statusMessage.value = "❌ Dio Error (${result['statusCode']})";
        Get.snackbar(
          "Dio Error",
          "Status: ${result['statusCode']}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on TimeoutException {
      statusMessage.value = "❌ Dio Timeout";
      responseLog.value = "❌ Dio Timeout: Server tidak merespon dalam 5 detik.";
      Get.snackbar(
        "Timeout (Dio)",
        "Server tidak merespon dalam 5 detik.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      statusMessage.value = "❌ Dio Exception: $e";
      responseLog.value = "❌ Dio Exception: $e";
      Get.snackbar(
        "Error Dio (Async)",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDio.value = false;
    }
  }

  /// CALLBACK CHAINING
  Future<void> fetchProgramsHttpCallbackChaining() async {
    isLoadingCallback.value = true;
    try {
      final result = await _httpService
          .fetchProgramsCallbackWithStatus()
          .timeout(const Duration(seconds: 5));

      httpProgramsCallback.value = result['data'];
      statusCode.value = result['statusCode'].toString();
      responseLog.value = result['raw'] ?? "";

      if (result['statusCode'] == 200) {
        statusMessage.value = "✅ Callback Success";
      } else {
        statusMessage.value = "❌ Callback Error (${result['statusCode']})";
        Get.snackbar(
          "Callback Error",
          "Status: ${result['statusCode']}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on TimeoutException {
      statusMessage.value = "❌ Callback Timeout";
      responseLog.value =
          "❌ Callback Timeout: Server tidak merespon dalam 5 detik.";
      Get.snackbar(
        "Timeout (Callback)",
        "Server tidak merespon dalam 5 detik.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      statusMessage.value = "❌ Callback Exception: $e";
      responseLog.value = "❌ Callback Exception: $e";
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
