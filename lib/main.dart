import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/UI/login/controllers/login_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/theme/theme_controller.dart';
import 'app/models/jadwal_model.dart';
import 'app/UI/jadwal/controllers/jadwal_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Hive.initFlutter();
  Hive.registerAdapter(JadwalModelAdapter()); 

  await Supabase.initialize(
    url: "https://pgrmuxoxruzkvgsqderg.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBncm11eG94cnV6a3Znc3FkZXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzMDUwMDgsImV4cCI6MjA3ODg4MTAwOH0.KiyCVlDVyBJat_ROdZCWrDIV5RnwRiwz7c8eF4Y7ih4",
  );

  Get.put(LoginController(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  Get.put(JadwalController(), permanent: true);

  runApp(const VolleyballActivityManagerApp());
}

class VolleyballActivityManagerApp extends StatelessWidget {
  const VolleyballActivityManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MVBT Activity Manager',

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeC.isDark.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: Routes.login,
        getPages: AppPages.routes,
      );
    });
  }
}
