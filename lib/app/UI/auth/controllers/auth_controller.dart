import 'package:get/get.dart';
import 'package:mvbtummaplikasi/services/auth_services.dart';

class AuthController extends GetxController {
  final auth = AuthService();

  RxBool isLoggedIn = false.obs;
  RxString userRole = "".obs;
  RxString userName = "".obs;

  Future<void> login(String email, String password) async {
    final res = await auth.login(email, password);

    if (res != null) {
      Get.snackbar("Error", res);
      return;
    }

    final user = await auth.getCurrentUserData();
    if (user == null) {
      Get.snackbar("Error", "Data user tidak ditemukan");
      return;
    }

    userName.value = user["name"];
    userRole.value = user["role"];
    isLoggedIn.value = true;

    Get.offAllNamed("/home");
  }

  Future<void> register(String email, String password, String name, String role) async {
    final res = await auth.register(
      email: email,
      password: password,
      name: name,
      role: role,
    );

    if (res != null) {
      Get.snackbar("Error", res);
      return;
    }

    Get.snackbar("Sukses", "Akun berhasil dibuat");
    Get.back();
  }

  void logout() async {
    await auth.logout();
    isLoggedIn.value = false;
    Get.offAllNamed("/login");
  }
}
