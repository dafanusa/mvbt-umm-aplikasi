import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/jadwal_model.dart';
import '../../../../services/local_notification_service.dart';

class JadwalController extends GetxController {
  final supabase = Supabase.instance.client;

  final events = <JadwalModel>[].obs;

  final selectedDay = Rxn<DateTime>();
  final focusedDay = DateTime.now().obs;
  final selectedFilter = "Semua".obs;

  @override
  void onInit() {
    super.onInit();
    fetchJadwal();
  }

  // ================= FETCH =================
  Future<void> fetchJadwal() async {
    final res = await supabase.from('jadwal').select().order('date');

    events.value = (res as List).map((e) => JadwalModel.fromJson(e)).toList();
  }

  Future<void> addJadwal(JadwalModel item) async {
    await supabase.from('jadwal').insert(item.toJson());

    // 🔔 SCHEDULE NOTIF H-1 JAM
    await LocalNotificationService.scheduleReminder(
      id: item.id,
      title: "Pengingat Jadwal",
      body: "${item.title} akan dimulai pukul ${item.time}",
      scheduledTime: item.jadwalTime.subtract(const Duration(hours: 1)),
      payload: {'type': 'jadwal', 'title': item.title},
    );

    fetchJadwal();
  }

  // ================= UPDATE =================
  Future<void> updateJadwal(JadwalModel item) async {
    await supabase.from('jadwal').update(item.toJson()).eq('id', item.id);

    // 🔄 CANCEL & RESCHEDULE
    await LocalNotificationService.cancel(item.id);
    await LocalNotificationService.scheduleReminder(
      id: item.id,
      title: "Pengingat Jadwal",
      body: "${item.title} akan dimulai pukul ${item.time}",
      scheduledTime: item.jadwalTime.subtract(const Duration(hours: 1)),
      payload: {'type': 'jadwal', 'title': item.title},
    );

    fetchJadwal();
  }

  // ================= DELETE =================
  Future<void> deleteJadwal(int id) async {
    await supabase.from('jadwal').delete().eq('id', id);

    // ❌ HAPUS NOTIF
    await LocalNotificationService.cancel(id);

    fetchJadwal();
  }

  // ================= CALENDAR =================
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }

  void setFilter(String f) {
    selectedFilter.value = f;

    if (f == "Semua") {
      selectedDay.value = null;
    }
  }

  List<JadwalModel> get filteredEvents {
    return events.where((e) {
      // FILTER TANGGAL
      final matchDate = selectedDay.value == null
          ? true
          : e.date.year == selectedDay.value!.year &&
                e.date.month == selectedDay.value!.month &&
                e.date.day == selectedDay.value!.day;

      // FILTER KATEGORI (DINAMIS)
      final matchCategory = selectedFilter.value == "Semua"
          ? true
          : e.category == selectedFilter.value;

      return matchDate && matchCategory;
    }).toList();
  }

  // ================= MARKERS =================
  List<DateTime> get latihanDates =>
      events.where((e) => e.category == "Latihan").map((e) => e.date).toList();

  List<DateTime> get pertandinganDates => events
      .where((e) => e.category == "Pertandingan")
      .map((e) => e.date)
      .toList();

  String formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";
}
