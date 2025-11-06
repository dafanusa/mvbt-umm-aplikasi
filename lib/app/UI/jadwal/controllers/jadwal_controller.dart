import 'package:get/get.dart';
import 'package:flutter/material.dart';

class JadwalItem {
  final String title;
  final DateTime date;
  final String time;
  final String category;

  JadwalItem({
    required this.title,
    required this.date,
    required this.time,
    required this.category,
  });
}

class JadwalController extends GetxController {
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  RxString selectedFilter = "Semua".obs;
  RxList<JadwalItem> events = <JadwalItem>[
    JadwalItem(
      title: "Latihan Teknik",
      date: DateTime(2025, 9, 17),
      time: "20.00 WIB",
      category: "Latihan",
    ),
    JadwalItem(
      title: "Latihan Fisik",
      date: DateTime(2025, 9, 22),
      time: "20.00 WIB",
      category: "Latihan",
    ),
    JadwalItem(
      title: "Latihan Passing",
      date: DateTime(2025, 9, 30),
      time: "20.00 WIB",
      category: "Latihan",
    ),
    JadwalItem(
      title: "FunMatch bersama UM",
      date: DateTime(2025, 10, 1),
      time: "19.00 WIB",
      category: "Pertandingan",
    ),
  ].obs;

  List<DateTime> get latihanDates =>
      events.where((e) => e.category == "Latihan").map((e) => e.date).toList();
  List<DateTime> get pertandinganDates => events
      .where((e) => e.category == "Pertandingan")
      .map((e) => e.date)
      .toList();
  List<JadwalItem> get filteredEvents {
    return events.where((e) {
      final isSameDay = selectedDay.value == null
          ? true
          : e.date.year == selectedDay.value!.year &&
                e.date.month == selectedDay.value!.month &&
                e.date.day == selectedDay.value!.day;

      final matchesFilter =
          selectedFilter.value == "Semua" || e.category == selectedFilter.value;

      return isSameDay && matchesFilter;
    }).toList();
  }

  get jadwalItems => null;
  void onDaySelected(DateTime day, DateTime focusDay) {
    selectedDay.value = day;
    focusedDay.value = focusDay;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  String formatDate(DateTime date) {
    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return "${_hari(date.weekday)}, ${date.day} ${bulan[date.month - 1]} ${date.year}";
  }

  String _hari(int d) {
    switch (d) {
      case 1:
        return "Senin";
      case 2:
        return "Selasa";
      case 3:
        return "Rabu";
      case 4:
        return "Kamis";
      case 5:
        return "Jumat";
      case 6:
        return "Sabtu";
      case 7:
        return "Minggu";
      default:
        return "";
    }
  }
}
