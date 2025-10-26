import 'package:flutter/foundation.dart' show kIsWeb;

String getBaseUrl() {
  if (kIsWeb) {
    return "http://127.0.0.1:8080";
  } else {
    return "http://10.0.2.2:8080";
  }
}

final String baseUrlLocal = getBaseUrl();
final String endpointPrograms = "$baseUrlLocal/programs";