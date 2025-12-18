import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../app/routes/app_pages.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'jadwal_channel';

  // ================= INIT =================
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidInit);

    tz.initializeTimeZones();

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == null) return;

        final data = jsonDecode(details.payload!);

        // 🔥 ARAHKAN KE HALAMAN JADWAL
        if (data['type'] == 'jadwal_test' || data['type'] == 'jadwal') {
          Get.toNamed('/jadwal');
        }
      },
    );
  }

  // ================= SHOW (INSTANT) =================
  static Future<void> show({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      'Jadwal & Kegiatan',
      channelDescription: 'Notifikasi latihan dan kegiatan',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notif_sound'),
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: jsonEncode(payload),
    );
  }

  // ================= SCHEDULE (H-1 JAM) =================
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required Map<String, dynamic> payload,
  }) async {
    // ❗ Jangan jadwalkan kalau waktunya sudah lewat
    if (scheduledTime.isBefore(DateTime.now())) return;

    final androidDetails = AndroidNotificationDetails(
      channelId,
      'Jadwal & Kegiatan',
      channelDescription: 'Pengingat jadwal kegiatan',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notif_sound'),
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      payload: jsonEncode(payload),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  // ================= CANCEL =================
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  // ================= CANCEL ALL =================
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
