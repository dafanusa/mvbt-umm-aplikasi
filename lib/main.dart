import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app/UI/login/controllers/login_controller.dart';
import 'app/UI/jadwal/controllers/jadwal_controller.dart';
import 'app/UI/notification/controllers/notification_controller.dart';

import 'services/firebase_notification_service.dart';
import 'services/local_notification_service.dart';

import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/theme/theme_controller.dart';

// 🎯 Route dari notifikasi TERMINATED
String? initialRouteFromNotification;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();

  if (initialMessage != null) {
    final data = initialMessage.data;
    final type = data['type'];
    final route = data['route'];

    if (route != null) {
      initialRouteFromNotification = route;
    } else if (type == 'jadwal') {
      initialRouteFromNotification = '/jadwal';
    } else if (type == 'program') {
      initialRouteFromNotification = '/program';
    }
  }

  // ================= LOCAL NOTIFICATION =================
  await LocalNotificationService.init();

  // ================= SUPABASE INIT =================
  await Supabase.initialize(
    url: "https://pgrmuxoxruzkvgsqderg.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBncm11eG94cnV6a3Znc3FkZXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzMDUwMDgsImV4cCI6MjA3ODg4MTAwOH0.KiyCVlDVyBJat_ROdZCWrDIV5RnwRiwz7c8eF4Y7ih4",
  );

  // ================= GLOBAL CONTROLLERS =================
  Get.put(LoginController(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  Get.put(JadwalController(), permanent: true);
  Get.put(NotificationController(), permanent: true);

  // ================= FCM HANDLER =================
  await FirebaseNotificationService.init();

  runApp(const VolleyballActivityManagerApp());
}

class VolleyballActivityManagerApp extends StatelessWidget {
  const VolleyballActivityManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();
    final notifC = Get.find<NotificationController>();

    // ================= INITIAL ROUTE =================
    String initialRoute = Routes.login;

    // ✅ HANYA JIKA APP DIBUKA DARI TERMINATED NOTIF
    if (initialRouteFromNotification != null) {
      initialRoute = Routes.mainNavigation;
      notifC.setInitialPendingRoute(initialRouteFromNotification!);
    }

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MVBT Activity Manager',

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeC.isDark.value ? ThemeMode.dark : ThemeMode.light,

        initialRoute: initialRoute,
        getPages: AppPages.routes,
      );
    });
  }
}
