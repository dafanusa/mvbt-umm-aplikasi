import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  RxList<EventItem> events = <EventItem>[].obs;

  late AnimationController headerController;
  late Animation<double> headerScale;

  @override
  void onInit() {
    super.onInit();

    events.value = [
      EventItem(
        title: 'Latihan Reguler',
        date: 'Sabtu, 18 Okt 2025',
        time: '07:00 - 09:00',
        location: 'Lapangan A',
      ),
      EventItem(
        title: 'Pertandingan Persahabatan',
        date: 'Minggu, 19 Okt 2025',
        time: '08:30 - 10:30',
        location: 'Lapangan B',
      ),
      EventItem(
        title: 'Seleksi Tim Kampus',
        date: 'Kamis, 23 Okt 2025',
        time: '15:00 - 17:00',
        location: 'Lapangan Indoor',
      ),
    ];

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

  void toggleExpand(int index) {
    events[index].expanded = !events[index].expanded;
    events.refresh();
  }

  void addEvent() {
    events.insert(
      0,
      EventItem(
        title: 'Event Baru',
        date: 'Segera',
        time: 'Waktu belum ditentukan',
        location: 'TBD',
      ),
    );
  }

  void editEvent(int index, String title, String date, String time, String location) {
    events[index].title = title;
    events[index].date = date;
    events[index].time = time;
    events[index].location = location;
    events.refresh();
  }

  @override
  void onClose() {
    headerController.dispose();
    super.onClose();
  }
}
