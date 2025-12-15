import 'package:hive/hive.dart';

class JadwalModel {
  final int id;
  final String title;
  final String time; // "19:00"
  final DateTime date; // untuk kalender (YYYY-MM-DD)
  final DateTime jadwalTime; // 🔥 FULL datetime (2025-12-15 19:00)
  final String category;

  JadwalModel({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.jadwalTime,
    required this.category,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      date: DateTime.parse(json['date']),
      jadwalTime: DateTime.parse(json['jadwal_time']),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'date': date.toIso8601String().substring(0, 10), // tetap
      'jadwal_time': jadwalTime.toIso8601String(), // 🔥 untuk reminder
      'category': category,
    };
  }
}
