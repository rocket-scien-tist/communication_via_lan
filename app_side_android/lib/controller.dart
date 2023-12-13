import 'package:communication_between_apps_without_internet/client.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';

class ClientController extends GetxController {
  ClientModel? clientModel;
  List<String> logs = [];
  int port = 4000;
  Stream<NetworkAddress>? stream;
  NetworkAddress? address;

  @override
  void onInit() {
    getIpAddress();
    super.onInit();
  }

  getIpAddress() {
    stream = NetworkAnalyzer.discover2('192.168.0', port);
    stream!.listen((NetworkAddress networkAddress) {
      if (networkAddress.exists) {
        address = networkAddress;
        clientModel = ClientModel(
            hostName: networkAddress.ip,
            port: port,
            onData: onData,
            onError: onError);
      }
    });
    update();
  }

  void sendMessage(String message) {
    logs.add('Me : $message');
    clientModel!.write(message);
    update();
  }

  onData(Uint8List data) {
    final message = String.fromCharCodes(data);
    logs.add(message);
    update();
  }

  onError(dynamic error) {
    debugPrint("Error: $error");
  }
}
