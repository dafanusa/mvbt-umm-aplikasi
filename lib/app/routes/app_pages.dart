import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../UI/login/views/login_view.dart';
import '../UI/login/controllers/login_controller.dart';
import '../UI/login/bindings/login_binding.dart';
import '../UI/register/views/register_view.dart';
import '../UI/register/bindings/register_binding.dart';
import '../UI/main_navigation/views/main_navigation_view.dart';
import '../UI/main_navigation/bindings/main_navigation_binding.dart';
import '../UI/home/views/home_view.dart';
import '../UI/home/bindings/home_binding.dart';
import '../UI/program/views/program_view.dart';
import '../UI/program/bindings/program_binding.dart';
import '../UI/gallery/views/gallery_view.dart';
import '../UI/gallery/bindings/gallery_binding.dart';
import '../UI/jadwal/views/jadwal_view.dart';
import '../UI/jadwal/bindings/jadwal_binding.dart';
import '../UI/profile/views/profile_view.dart';
import '../UI/profile/bindings/profile_binding.dart';
import '../UI/location/views/location_view.dart';
import '../UI/gps_location/views/gps_map_view.dart';
import '../UI/network_location/views/network_map_view.dart';
import '../UI/location/bindings/location_binding.dart';
import '../UI/gps_location/bindings/gps_map_binding.dart';
import '../UI/network_location/bindings/network_map_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(maroon: Color(0xFF800000)),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.register,
      page: () => const RegisterView(maroon: Color(0xFF800000)),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: Routes.mainNavigation,
      page: () =>
          const MainNavigationView(username: '', maroon: Color(0xFF800000)),
      binding: MainNavigationBinding(),
    ),

    GetPage(
      name: Routes.home,
      page: () => const HomeView(maroon: Color(0xFF800000), username: ''),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.program,
      page: () => ProgramView(maroon: Color(0xFF800000)),
      binding: ProgramBinding(),
    ),

    GetPage(
      name: Routes.gallery,
      page: () => const GalleryView(maroon: Color(0xFF800000)),
      binding: GalleryBinding(),
    ),

    GetPage(
      name: Routes.jadwal,
      page: () => const JadwalView(maroon: Color(0xFF800000)),
      binding: JadwalBinding(),
    ),

    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(username: ''),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.location,
      page: () => const LocationView(maroon: Color(0xFF800000)),
      binding: LocationBinding(),
    ),
    GetPage(
      name: Routes.gps,
      page: () => const GpsMapView(),
      binding: GpsMapBinding(),
    ),
    GetPage(
      name: Routes.network,
      page: () => const NetworkMapView(),
      binding: NetworkMapBinding(),
    ),
  ];
}
