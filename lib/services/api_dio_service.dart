import 'dart:convert';
import 'package:dio/dio.dart';
import '../app/models/program_model.dart';

class ApiDioService {
  static const String baseUrl = "https://api-mvbtaplikasi-nodejs.vercel.app";
  static const String endpointPrograms = "/programs";

  final Dio _dio = Dio();

  ApiDioService() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print("📘 [DIO LOG] $obj"),
    ));
  }

  Future<Map<String, dynamic>> fetchProgramsWithStatus() async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _dio.get(endpointPrograms);
      stopwatch.stop();

      final log = StringBuffer()
        ..writeln("🔹 [DIO LOG]")
        ..writeln("Base URL: $baseUrl")
        ..writeln("Endpoint: $endpointPrograms")
        ..writeln("Method: GET")
        ..writeln("Status Code: ${response.statusCode}")
        ..writeln("Duration: ${stopwatch.elapsedMilliseconds} ms");

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return {
          'statusCode': response.statusCode,
          'data': data.map((e) => ProgramModel.fromJson(e)).toList(),
          'raw': log.toString(),
        };
      } else {
        return {
          'statusCode': response.statusCode ?? 500,
          'data': <ProgramModel>[],
          'raw': "❌ DIO Error (Status: ${response.statusCode})\n${log.toString()}",
        };
      }
    } on DioException catch (e) {
      stopwatch.stop();
      final code = e.response?.statusCode ?? 500;
      final msg = e.message ?? 'Unknown Dio Error';

      final log = StringBuffer()
        ..writeln("❌ [DIO EXCEPTION]")
        ..writeln("Error: $msg")
        ..writeln("Duration: ${stopwatch.elapsedMilliseconds} ms");

      return {
        'statusCode': code,
        'data': <ProgramModel>[],
        'raw': log.toString(),
      };
    } catch (e) {
      stopwatch.stop();
      return {
        'statusCode': 500,
        'data': <ProgramModel>[],
        'raw': "❌ DIO Unknown Error: $e\nDurasi: ${stopwatch.elapsedMilliseconds} ms",
      };
    }
  }
}