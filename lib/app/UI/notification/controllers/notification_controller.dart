import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/services/local_notification_service.dart';
import '/app/routes/app_pages.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

class NotificationController extends GetxController {
  final lastPayload = ''.obs;
  final pendingRoute = RxnString();
  int? _pendingTabIndex;

  final _supabase = Supabase.instance.client;

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
          await _saveTokenToSupabase(token); // 🔥 PENTING
        }
      }

      // 🔄 JIKA TOKEN BERUBAH
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        print('🔄 FCM TOKEN UPDATED: $newToken');
        await _saveTokenToSupabase(newToken);
      });
    } catch (e) {
      print('❌ FCM TOKEN ERROR: $e');
    }
  }

  // ===================================
  //     SIMPAN TOKEN KE SUPABASE
  // ===================================
  Future<void> _saveTokenToSupabase(String fcmtoken) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return;
    }

    await _supabase.from('users').upsert({
      'id': user.id,
      'fcm_token': fcmtoken,
      'updated_at': DateTime.now().toIso8601String(),
    });
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
    // BACKGROUND → MAIN NAV
    // ============================
    if (fromBackground) {
      Get.offAllNamed(Routes.mainNavigation);
    }
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
