import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(VolleyballActivityManagerApp());
}

class VolleyballActivityManagerApp extends StatelessWidget {
  final Color maroon = const Color(0xFF800000);

  const VolleyballActivityManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVBT Activity Manager',
      theme: ThemeData(
        primaryColor: maroon,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: maroon),
        fontFamily: 'Poppins',
      ),
      home: LoginPage(maroon: maroon),
    );
  }
}
