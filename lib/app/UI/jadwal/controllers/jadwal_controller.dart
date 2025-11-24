import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../models/jadwal_model.dart';
import '../../login/controllers/login_controller.dart';

class JadwalController extends GetxController {
  // ROLE
  final loginC = Get.find<LoginController>();

  // HIVE BOX
  late Box<JadwalModel> _jadwalBox;

  // STATE FOR UI
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  RxString selectedFilter = "Semua".obs;

  // LIST DATA JADWAL
  RxList<JadwalModel> events = <JadwalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _openHiveBox();
  }

  // =====================================================
  // HIVE OPEN BOX & LOAD DATA
  // =====================================================

  Future<void> _openHiveBox() async {
    _jadwalBox = await Hive.openBox<JadwalModel>('jadwal');
    loadJadwal();
  }

  void loadJadwal() {
    events.value = _jadwalBox.values.toList();
  }

  // AUTO INCREMENT ID
  int get nextId => _jadwalBox.isEmpty ? 1 : _jadwalBox.values.last.id + 1;

  // =====================================================
  // FILTERING
  // =====================================================

  List<JadwalModel> get filteredEvents {
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

  List<DateTime> get latihanDates =>
      events.where((e) => e.category == "Latihan").map((e) => e.date).toList();

  List<DateTime> get pertandinganDates => events
      .where((e) => e.category == "Pertandingan")
      .map((e) => e.date)
      .toList();

  void onDaySelected(DateTime day, DateTime focusDay) {
    selectedDay.value = day;
    focusedDay.value = focusDay;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  // =====================================================
  // FORMAT HARI & TANGGAL
  // =====================================================

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

  // =====================================================
  // CRUD REAL DENGAN HIVE
  // =====================================================

  Future<void> addJadwal(JadwalModel item) async {
    if (loginC.userRole.value != "admin") {
      Get.snackbar("Akses Ditolak", "Hanya admin yang boleh menambah jadwal");
      return;
    }

    await _jadwalBox.add(item);
    loadJadwal();

    Get.snackbar("Sukses", "Jadwal berhasil ditambahkan");
  }

  /// 🔥 UPDATE MENGGUNAKAN 1 ARGUMEN SAJA (JadwalModel)
  Future<void> updateJadwal(JadwalModel updated) async {
    if (loginC.userRole.value != "admin") {
      Get.snackbar("Akses Ditolak", "Hanya admin yang boleh mengedit jadwal");
      return;
    }

    // cari index berdasarkan ID
    int index = _jadwalBox.values.toList().indexWhere((e) => e.id == updated.id);

    if (index == -1) {
      Get.snackbar("Error", "Jadwal tidak ditemukan");
      return;
    }

    await _jadwalBox.putAt(index, updated);
    loadJadwal();

    Get.snackbar("Sukses", "Jadwal berhasil diperbarui");
  }

  Future<void> deleteJadwal(int id) async {
    if (loginC.userRole.value != "admin") {
      Get.snackbar("Akses Ditolak", "Hanya admin yang boleh menghapus jadwal");
      return;
    }

    // cari index berdasarkan ID
    int index = _jadwalBox.values.toList().indexWhere((e) => e.id == id);

    if (index == -1) {
      Get.snackbar("Error", "Jadwal tidak ditemukan");
      return;
    }

    await _jadwalBox.deleteAt(index);
    loadJadwal();

    Get.snackbar("Sukses", "Jadwal berhasil dihapus");
  }
}
