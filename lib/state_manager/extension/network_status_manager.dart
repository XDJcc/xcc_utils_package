import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

typedef NetworkStatusChanged = void Function(ConnectivityResult status);


extension StatusExtensions on ConnectivityResult {
  bool get isConnected => this != ConnectivityResult.none;

  bool get isMobile => this == ConnectivityResult.mobile;

  bool get isWifi => this == ConnectivityResult.wifi;
}

class NetworkStatusManager {
  ConnectivityResult? _networkStatus;

  ConnectivityResult get networkStatus =>
      _networkStatus ?? ConnectivityResult.none;

  Connectivity? _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;
  NetworkStatusChanged statusChanged;

  NetworkStatusManager({required this.statusChanged});

  static Future<NetworkStatusManager> create(
      {required NetworkStatusChanged statusChanged}) async {
    final instance = NetworkStatusManager(statusChanged: statusChanged);
    await instance.initNetworkStatus();
    return instance;
  }

  Future<void> initNetworkStatus() async {
    _connectivity = Connectivity();
    try {
      _networkStatus = (await _connectivity!.checkConnectivity());
      statusChanged(_networkStatus ?? ConnectivityResult.none);
    } on PlatformException catch (e) {
      debugPrint(
          'NetworkStatus -- message:${e.message} stacktrace ${e.stacktrace}');
    }
  }

  void startListening() {
    _subscription = _connectivity?.onConnectivityChanged.listen((result) {
      statusChanged(result);
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
