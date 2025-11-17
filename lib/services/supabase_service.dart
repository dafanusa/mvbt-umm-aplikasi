import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/models/program_model.dart';

class SupabaseService {
  final String baseUrl =
      "https://pgrmuxoxruzkvgsqderg.supabase.co/rest/v1";
  final String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBncm11eG94cnV6a3Znc3FkZXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzMDUwMDgsImV4cCI6MjA3ODg4MTAwOH0.KiyCVlDVyBJat_ROdZCWrDIV5RnwRiwz7c8eF4Y7ih4";

  Map<String, String> get headers => {
        "apikey": apiKey,
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      };

  /// GET PROGRAMS
  Future<List<ProgramModel>> fetchPrograms() async {
    final response = await http.get(
      Uri.parse("$baseUrl/programs?select=*"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => ProgramModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Gagal mengambil data program");
    }
  }

  /// ADD PROGRAM (tanggal otomatis)
  Future<bool> addProgram(ProgramModel program) async {
    final body = {
      "title": program.title,
      "description": program.description,
      "date": DateTime.now().toIso8601String(), // otomatis
      "status": program.status,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/programs"),
      headers: headers,
      body: jsonEncode(body),
    );

    return response.statusCode == 201;
  }

  /// UPDATE PROGRAM
  Future<bool> updateProgram(ProgramModel program) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/programs?id=eq.${program.id}"),
      headers: headers,
      body: jsonEncode(program.toJson()),
    );

    return response.statusCode == 204;
  }

  /// DELETE PROGRAM
  Future<bool> deleteProgram(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/programs?id=eq.$id"),
      headers: headers,
    );

    return response.statusCode == 204;
  }
}
