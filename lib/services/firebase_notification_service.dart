import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../app/UI/notification/controllers/notification_controller.dart';

class FirebaseNotificationService {
  static final _fcm = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    /// 🔵 FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().onForeground(message);
      }
    });

    /// 🟡 BACKGROUND (tap notif)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleOpened(message.data, fromBackground: true);
    });

    /// 🔴 TERMINATED
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      _handleOpened(message.data, fromBackground: false);
    }
  }

  // =========================
  // SAFE HANDLER
  // =========================
  static void _handleOpened(
    Map<String, dynamic> data, {
    required bool fromBackground,
  }) {
    /// tunggu sampai controller siap
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return !Get.isRegistered<NotificationController>();
    }).then((_) {
      Get.find<NotificationController>().onOpened(
        data,
        fromBackground: fromBackground,
      );
    });
  }
}