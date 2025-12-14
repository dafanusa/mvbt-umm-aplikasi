import 'package:hive/hive.dart';

class JadwalModel {
  final int id;
  final String title;
  final String time;
  final DateTime date;
  final String category;

  JadwalModel({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.category,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'date': date.toIso8601String().substring(0, 10), // YYYY-MM-DD
      'category': category,
    };
  }
}
