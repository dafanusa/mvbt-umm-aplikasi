import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '/services/local_notification_service.dart';
import '/app/routes/app_pages.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

class NotificationController extends GetxController {
  final lastPayload = ''.obs;

  /// 🔥 SUDAH ADA
  final pendingRoute = RxnString();

  /// simpan index tab (jadwal / program)
  int? _pendingTabIndex;

  // ===================================
  //              INIT
  // ===================================
  @override
  void onInit() {
    super.onInit();
    _setupFCMToken();
  }

  // ===================================
  //           FCM TOKEN
  // ===================================
  Future<void> _setupFCMToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          print('🔥 FCM TOKEN: $token');
        }
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print('🔄 FCM TOKEN UPDATED: $newToken');
      });
    } catch (e) {
      print('❌ FCM TOKEN ERROR: $e');
    }
  }

  /// 🔴 TERMINATED (dipanggil dari main.dart)
  void setInitialPendingRoute(String route) {
    pendingRoute.value = route;
    print("🔔 PENDING ROUTE diset dari main.dart: $route");
  }

  // =================================================
  //            DIPANGGIL DARI SERVICE
  // =================================================

  /// 🔵 FOREGROUND
  void onForeground(RemoteMessage message) {
    final data = message.data;
    lastPayload.value = data.toString();

    LocalNotificationService.show(
      title: message.notification?.title ?? 'Pengingat Jadwal',
      body: message.notification?.body ?? '',
      payload: data,
    );

    print('📩 FOREGROUND DATA: $data');
  }

  /// 🟡 BACKGROUND & 🔴 TERMINATED
  void onOpened(Map<String, dynamic> data, {bool fromBackground = false}) {
    print('📬 OPENED DATA: $data');

    final route = data['route'];
    final type = data['type'];

    // ============================
    // TENTUKAN TAB
    // ============================
    if (type == 'jadwal' || route == '/jadwal') {
      _pendingTabIndex = 2; //
    } else if (type == 'jadwal' || route == '/jadwal') {
      _pendingTabIndex = 2; //
    }

    // ============================
    // BACKGROUND → MASUK MAIN NAV
    // ============================
    if (fromBackground) {
      Get.offAllNamed(Routes.mainNavigation);
    }

    print('🔔 Pending tab index: $_pendingTabIndex');
  }

  // ===================================
  //     DIPANGGIL SETELAH MAIN NAV SIAP
  // ===================================
  void consumePendingRoute() {
    if (_pendingTabIndex != null &&
        Get.isRegistered<MainNavigationController>()) {
      final index = _pendingTabIndex!;
      _pendingTabIndex = null;

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.find<MainNavigationController>().changeTab(index);
        print("✅ Pindah ke tab dari notifikasi: $index");
      });
    }
  }
}
