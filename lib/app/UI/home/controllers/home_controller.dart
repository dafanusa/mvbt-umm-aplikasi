import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mvbtummaplikasi/app/routes/app_pages.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

class EventItem {
  String title;
  String date;
  String time;
  String location;
  bool expanded;

  EventItem({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    this.expanded = false,
  });
}

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<EventItem> events = <EventItem>[].obs;
  RxString todaySchedule = "Belum ada jadwal terdekat.".obs;
  RxString latestAnnouncement = "Tidak ada pengumuman baru saat ini.".obs;

  late AnimationController headerController;
  late Animation<double> headerScale;

  @override
  void onInit() {
    super.onInit();

    _initializeEvents();
    _initializeAnnouncements();
    _setTodaySchedule();

    headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    headerScale = CurvedAnimation(
      parent: headerController,
      curve: Curves.easeOutBack,
    );

    headerController.forward();
  }

  String _getIndonesianDay(int weekday) {
    const days = [
      '',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[weekday % 7 == 0 ? 7 : weekday % 7];
  }

  String _getIndonesianMonth(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month];
  }

  // ===================== Inisialisasi Data =====================
  void _initializeEvents() {
    events.value = [
      EventItem(
        title: 'Latihan Reguler',
        date: '2025-11-01',
        time: '18:00',
        location: 'Lapangan A',
      ),
      EventItem(
        title: 'Rapat Persiapan Turnamen 📋',
        date: '2025-11-03',
        time: '10:00',
        location: 'Ruang Rapat Utama',
      ),
      EventItem(
        title: 'Pertandingan Persahabatan 🤝',
        date: '2025-11-05',
        time: '08:30',
        location: 'Lapangan B',
      ),
    ];
    events.sort((a, b) {
      DateTime dateA = DateTime.parse('${a.date} ${a.time.substring(0, 5)}:00');
      DateTime dateB = DateTime.parse('${b.date} ${b.time.substring(0, 5)}:00');
      return dateA.compareTo(dateB);
    });
  }

  void _initializeAnnouncements() {
    latestAnnouncement.value =
        "Rapat evaluasi hari ini pukul 10:00 dibatalkan! Jadwal baru akan diumumkan segera.";
  }

  void _setTodaySchedule() {
    try {
      final now = DateTime.now();

      final upcomingEvents = events.where((event) {
        final eventDateTime = DateTime.parse(
          '${event.date} ${event.time.substring(0, 5)}:00',
        );
        return eventDateTime.isAfter(now);
      }).toList();

      if (upcomingEvents.isEmpty) {
        todaySchedule.value =
            "Anda tidak memiliki jadwal kegiatan dalam waktu dekat.";
        return;
      }

      final nextEvent = upcomingEvents.first;
      final nextEventDate = DateTime.parse(nextEvent.date);

      final dayName = _getIndonesianDay(nextEventDate.weekday);
      final dayOfMonth = nextEventDate.day;
      final monthName = _getIndonesianMonth(nextEventDate.month);

      final eventDateFormatted =
          '$dayName, $dayOfMonth $monthName ${nextEventDate.year}';

      todaySchedule.value =
          "${nextEvent.title} pada $eventDateFormatted pukul ${nextEvent.time.substring(0, 5)} di ${nextEvent.location}.";
    } catch (e) {
      todaySchedule.value = "Gagal memuat jadwal hari ini.";
      print("Error loading today schedule: $e");
    }
  }

  // ===================== Navigasi dengan Efek =====================
  void goToSchedule() async {
    try {
      final mainController = Get.find<MainNavigationController>();

      // Animasi kecil saat ditekan
      Get.snackbar(
        "📅 Membuka Jadwal",
        "Menampilkan semua kegiatan MVBT UMM",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 128, 0, 0),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );

      await Future.delayed(const Duration(milliseconds: 400));

      mainController.changeTab(2);
      print("Pindah Tab ke Jadwal");
    } catch (e) {
      print("Error finding MainNavigationController: $e");
    }
  }

  void goToAnnouncements() async {
    try {
      final mainController = Get.find<MainNavigationController>();

      Get.snackbar(
        "📢 Membuka Pengumuman",
        "Menampilkan semua pengumuman terbaru...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );

      await Future.delayed(const Duration(milliseconds: 400));

      mainController.changeTab(1);
      print(">>> Pindah Tab ke Pengumuman (Index 1) <<<");
    } catch (e) {
      print("Error finding MainNavigationController: $e");
    }
  }

  @override
  void onClose() {
    headerController.dispose();
    super.onClose();
  }
}
