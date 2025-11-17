import 'package:hive/hive.dart';
import '../app/models/jadwal_model.dart';

class JadwalHiveService {
  static const String boxName = 'jadwalBox';

  // Open box
  static Future<Box<JadwalModel>> openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<JadwalModel>(boxName);
    }
    return await Hive.openBox<JadwalModel>(boxName);
  }

  // Get all data
  static Future<List<JadwalModel>> getAllJadwal() async {
    final box = await openBox();
    return box.values.toList();
  }

  // Add new jadwal
  static Future<void> addJadwal(JadwalModel jadwal) async {
    final box = await openBox();
    await box.put(jadwal.id, jadwal);
  }

  // Update jadwal
  static Future<void> updateJadwal(JadwalModel jadwal) async {
    final box = await openBox();
    await box.put(jadwal.id, jadwal);
  }

  // Delete jadwal by id
  static Future<void> deleteJadwal(int id) async {
    final box = await openBox();
    await box.delete(id);
  }

  // Clear all data
  static Future<void> clear() async {
    final box = await openBox();
    await box.clear();
  }
}
