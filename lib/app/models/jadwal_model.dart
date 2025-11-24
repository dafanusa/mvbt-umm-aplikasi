import 'package:hive/hive.dart';

part 'jadwal_model.g.dart';

@HiveType(typeId: 1)
class JadwalModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String time;

  @HiveField(4)
  String category;

  JadwalModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.category,
  });
}
