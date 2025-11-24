import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/UI/login/views/login_view.dart';
import 'app/routes/app_pages.dart';


void main() {
  runApp(const VolleyballActivityManagerApp());
}

class VolleyballActivityManagerApp extends StatelessWidget {
  final Color maroon = const Color(0xFF800000);

  const VolleyballActivityManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVBT Activity Manager',
      theme: ThemeData(
        primaryColor: maroon,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: maroon),
        fontFamily: 'Poppins',
      ),
      initialRoute: Routes.login, 
      getPages: AppPages.routes,  
    );
  }
}
