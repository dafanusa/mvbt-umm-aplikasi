import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../app/models/program_model.dart';

class ApiHttpService {
  static const String endpointPrograms =
      "https://api-mvbtaplikasi-nodejs.vercel.app/programs";

  /// HTTP ASYNC
  Future<Map<String, dynamic>> fetchProgramsWithStatus() async {
    final stopwatch = Stopwatch()..start();
    final url = Uri.parse(endpointPrograms);

    try {
      final response = await http.get(url);
      stopwatch.stop();

      final log = StringBuffer()
        ..writeln("🔹 [HTTP LOG]")
        ..writeln("URL: $endpointPrograms")
        ..writeln("Method: GET")
        ..writeln("Status Code: ${response.statusCode}")
        ..writeln("Duration: ${stopwatch.elapsedMilliseconds} ms");

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return {
          'statusCode': response.statusCode,
          'data': data.map((e) => ProgramModel.fromJson(e)).toList(),
          'raw': log.toString(),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'data': <ProgramModel>[],
          'raw': "❌ HTTP Error (Status: ${response.statusCode})\n${log.toString()}",
        };
      }
    } catch (e) {
      stopwatch.stop();
      return {
        'statusCode': 500,
        'data': <ProgramModel>[],
        'raw': "❌ HTTP Exception: $e\nDurasi: ${stopwatch.elapsedMilliseconds} ms",
      };
    }
  }

  ///  HTTP CALLBACK 
  Future<Map<String, dynamic>> fetchProgramsCallbackWithStatus() {
    final stopwatch = Stopwatch()..start();
    final url = Uri.parse(endpointPrograms);
    final completer = Completer<Map<String, dynamic>>();

    http.get(url).then((response) {
      stopwatch.stop();

      final log = StringBuffer()
        ..writeln("🔹 [HTTP CALLBACK LOG]")
        ..writeln("URL: $endpointPrograms")
        ..writeln("Method: GET")
        ..writeln("Status Code: ${response.statusCode}")
        ..writeln("Duration: ${stopwatch.elapsedMilliseconds} ms");

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        completer.complete({
          'statusCode': response.statusCode,
          'data': data.map((e) => ProgramModel.fromJson(e)).toList(),
          'raw': log.toString(),
        });
      } else {
        completer.complete({
          'statusCode': response.statusCode,
          'data': <ProgramModel>[],
          'raw': "❌ Callback Error (Status: ${response.statusCode})\n${log.toString()}",
        });
      }
    }).catchError((error) {
      stopwatch.stop();
      completer.complete({
        'statusCode': 500,
        'data': <ProgramModel>[],
        'raw': "❌ Callback Exception: $error\nDurasi: ${stopwatch.elapsedMilliseconds} ms",
      });
    });

    return completer.future;
  }
}