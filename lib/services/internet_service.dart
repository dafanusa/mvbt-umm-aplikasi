import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  InternetService() {
    _connectivity.onConnectivityChanged.listen((status) {
      final isConnected = status != ConnectivityResult.none;
      _controller.sink.add(isConnected);
    });
  }

  Stream<bool> get connectionStream => _controller.stream;

  Future<bool> checkConnection() async {
    final status = await _connectivity.checkConnectivity();
    return status != ConnectivityResult.none;
  }

  void dispose() => _controller.close();
}
