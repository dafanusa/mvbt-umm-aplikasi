import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// INIT (WAJIB DIPANGGIL DI main.dart)
  static Future<void> init() async {
    // ANDROID INIT
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        if (payload.payload != null) {
          final data = jsonDecode(payload.payload!);
          _handleNavigation(data);
        }
      },
    );

    // FIREBASE PERMISSION
    await FirebaseMessaging.instance.requestPermission();

    // 🔥 FOREGROUND
    FirebaseMessaging.onMessage.listen(_onMessage);

    // 🔥 BACKGROUND (klik notif)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message.data);
    });

    // 🔥 TERMINATED
    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data);
    }
  }

  // ================= FOREGROUND =================
  static void _onMessage(RemoteMessage message) {
    debugPrint("🔥 FOREGROUND DATA: ${message.data}");

    _showLocalNotification(
      title: message.notification?.title ?? 'Notifikasi',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  // ================= LOCAL NOTIF =================
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'jadwal_channel',
      'Jadwal & Kegiatan',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notif'),
    );

    const notifDetails = NotificationDetails(android: androidDetails);

    await _localNotif.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notifDetails,
      payload: jsonEncode(payload),
    );
  }

  // ================= NAVIGATION =================
  static void _handleNavigation(Map<String, dynamic> data) {
    final type = data['type'];

    if (type == 'jadwal') {
      Get.toNamed('/jadwal');
    } else if (type == 'program') {
      Get.toNamed('/program');
    }
  }
}