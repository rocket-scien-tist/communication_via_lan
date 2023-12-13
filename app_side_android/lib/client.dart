import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';

typedef Unit8ListCallback = Function(Uint8List);
typedef DynamicCallback = Function(dynamic);

final deviceInfo = DeviceInfoPlugin();

class ClientModel {
  final String hostName;
  final int port;
  final Unit8ListCallback onData;
  final DynamicCallback onError;

  ClientModel({
    required this.hostName,
    required this.port,
    required this.onData,
    required this.onError,
  });

  bool isConnected = false;
  Socket? socket;

  Future<void> connect() async {
    try {
      socket = await Socket.connect(hostName, port);

      socket!.listen(onData, onError: onError, onDone: () async {
        final info = await deviceInfo.androidInfo;
        disconnect(info);
        isConnected = false;
      });
      isConnected = true;
    } catch (e) {
      debugPrint('error in connection : $e');
    }
  }

  void write(String message) {
    debugPrint('the writing message: $message');
    Map<String, dynamic> json = {
      "name": 'Ravshanbek',
      'last_name': 'Xojamuratov'
    };
    socket!.write(jsonEncode(json));
  }

  void disconnect(AndroidDeviceInfo info) {
    final message = "${info.brand} ${info.device} got disconnected";
    write(message);
    if (socket != null) {
      socket!.destroy();
    }
    isConnected = false;
  }
}
