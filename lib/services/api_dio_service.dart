import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/program_model.dart';

class ApiDioService {
  static const String baseUrl = "https://api-mvbtaplikasi-nodejs.vercel.app";
  static const String endpointPrograms = "/programs";

  final Dio _dio = Dio();

  ApiDioService() {
    _dio.options.baseUrl = baseUrl; 
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Future<List<ProgramModel>> fetchProgramsAsync() async {
    try {
      final response = await _dio.get(endpointPrograms);

      final List data = response.data;
      return data.map((e) => ProgramModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception("Dio Server Error: ${e.response!.statusCode}");
      }
      throw Exception("Dio Connection Error: ${e.message}");
    } catch (e) {
      throw Exception("Dio General Error: ${e.toString()}");
    }
  }
}