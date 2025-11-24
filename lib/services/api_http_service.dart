import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../app/models/program_model.dart';
import '../services/api_services.dart';

class ApiHttpService implements ApiService {
  static const String baseUrl =
      "https://api-mvbtaplikasi-nodejs.vercel.app/programs";

  // ============================================================
  // GET — HTTP
  // ============================================================
  Future<Map<String, dynamic>> fetchProgramsWithStatusHttp() async {
    final stopwatch = Stopwatch()..start();
    final url = Uri.parse(baseUrl);

    try {
      final response = await http
          .get(url, headers: {"Accept": "application/json"})
          .timeout(const Duration(seconds: 12));

      stopwatch.stop();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is! List) {
          return {
            'statusCode': 500,
            'data': <ProgramModel>[],
          };
        }

        final data = decoded.map((e) => ProgramModel.fromJson(e)).toList();

        return {
          'statusCode': 200,
          'data': data,
        };
      }

      return {
        'statusCode': response.statusCode,
        'data': <ProgramModel>[],
      };
    } catch (_) {
      stopwatch.stop();
      return {
        'statusCode': 500,
        'data': <ProgramModel>[],
      };
    }
  }

  // ============================================================
  // POST — HTTP
  // ============================================================
  Future<bool> addProgramHttp(ProgramModel program) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(program.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ============================================================
  // PUT — HTTP
  // ============================================================
  Future<bool> updateProgramHttp(ProgramModel program) async {
    final url = Uri.parse("$baseUrl/${program.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(program.toJson()),
    );

    return response.statusCode == 200;
  }

  // ============================================================
  // DELETE — HTTP
  // ============================================================
  Future<bool> deleteProgramHttp(int id) async {
    final url = Uri.parse("$baseUrl/$id");

    final response = await http.delete(url);

    return response.statusCode == 200;
  }

  // ============================================================
  // IMPLEMENTASI INTERFACE
  // ============================================================
  @override
  Future<Map<String, dynamic>> fetchProgramsWithStatus() {
    return fetchProgramsWithStatusHttp();
  }

  @override
  Future<bool> addProgram(ProgramModel program) {
    return addProgramHttp(program);
  }

  @override
  Future<bool> updateProgram(ProgramModel program) {
    return updateProgramHttp(program);
  }

  @override
  Future<bool> deleteProgram(int id) {
    return deleteProgramHttp(id);
  }
}
