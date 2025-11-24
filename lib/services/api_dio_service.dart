import 'dart:convert';
import 'package:dio/dio.dart';
import '../app/models/program_model.dart';
import '../services/api_services.dart';

class ApiDioService implements ApiService {
  static const String baseUrl = "https://api-mvbtaplikasi-nodejs.vercel.app";
  static const String endpointPrograms = "/programs";

  final Dio _dio = Dio();

  ApiDioService() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // ============================================================
  // GET — DIO
  // ============================================================
  @override
  Future<Map<String, dynamic>> fetchProgramsWithStatus() async {
    try {
      final response = await _dio.get(endpointPrograms);

      if (response.statusCode == 200 && response.data is List) {
        final List list = response.data;
        return {
          'statusCode': 200,
          'data': list.map((e) => ProgramModel.fromJson(e)).toList(),
        };
      }

      return {
        'statusCode': response.statusCode ?? 500,
        'data': <ProgramModel>[],
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': <ProgramModel>[],
      };
    }
  }

  // ============================================================
  // POST — DIO
  // ============================================================
  @override
  Future<bool> addProgram(ProgramModel program) async {
    final response = await _dio.post(
      endpointPrograms,
      data: program.toJson(),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ============================================================
  // PUT — DIO
  // ============================================================
  @override
  Future<bool> updateProgram(ProgramModel program) async {
    final response = await _dio.put(
      "$endpointPrograms/${program.id}",
      data: program.toJson(),
    );

    return response.statusCode == 200;
  }

  // ============================================================
  // DELETE — DIO
  // ============================================================
  @override
  Future<bool> deleteProgram(int id) async {
    final response = await _dio.delete("$endpointPrograms/$id");
    return response.statusCode == 200;
  }
}
