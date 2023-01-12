import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'network_status_manager.dart';

mixin NetworkConnectMixin on ChangeNotifier {
  NetworkStatusManager? _networkManager;

  ConnectivityResult get networkStatus =>
      _networkManager?.networkStatus ?? ConnectivityResult.none;

  @protected
  Future<void> initStatus() async {
    _networkManager = await NetworkStatusManager.create(
        statusChanged: networkConnectionChanged);
    startListening();
  }

  @protected
  void networkConnectionChanged(ConnectivityResult status) {}

  @protected
  void startListening() {
    _networkManager?.startListening();
  }

  @protected
  void stopListening() {
    _networkManager?.stopListening();
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    stopListening();
  }
}

mixin StateNetworkMixin<T extends StatefulWidget> on State<T> {
  NetworkStatusManager? _networkManager;

  ConnectivityResult get networkStatus =>
      _networkManager?.networkStatus ?? ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    initStatus();
  }

  @protected
  Future<void> initStatus() async {
    _networkManager = await NetworkStatusManager.create(
        statusChanged: networkConnectionChanged);
    startListening();
  }

  @protected
  void networkConnectionChanged(ConnectivityResult status) {}

  @protected
  void startListening() {
    _networkManager?.startListening();
  }

  @protected
  void stopListening() {
    _networkManager?.stopListening();
  }

  @override
  void dispose() {
    super.dispose();
    stopListening();
  }
}
