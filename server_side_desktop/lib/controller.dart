import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:server_side_desktop/server.dart';

class ServerController extends GetxController {
  Server? server;
  List<String> serverLogs = [];
  TextEditingController messageController = TextEditingController();

  Future<void> startOrStopServer() async {
    if (server!.running) {
      await server!.close();
      serverLogs.clear();
    } else {
      await server!.start();
    }
    update();
  }

  @override
  void onInit() {
    server = Server(onData, onError);
    startOrStopServer();
    super.onInit();
  }

  void onData(Uint8List data) {
    final receivedData = String.fromCharCodes(data);
    final decoded = jsonDecode(receivedData);
    serverLogs.add(receivedData);
    update();
  }

  void onError(dynamic error) {
    debugPrint('Error: $error');
  }

  void handleMessage() {
    server!.broadcast(messageController.text);
    // serverLogs.add(messageController.text);
    messageController.clear();
    update();
  }
}
