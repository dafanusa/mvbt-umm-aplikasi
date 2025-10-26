import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/program_model.dart';
import '../utils/app_constant.dart';

class ApiDioService {
  final Dio _dio = Dio();

  ApiDioService() {
    _dio.options.baseUrl = baseUrlLocal;
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Future<List<ProgramModel>> fetchProgramsAsync() async {
    try {
      final response = await _dio.get('/programs');

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