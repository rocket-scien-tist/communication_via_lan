import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

typedef Unit8ListCallback = Function(Uint8List);
typedef DynamicCallback = Function(dynamic);

class Server {
  final Unit8ListCallback? onData;
  final DynamicCallback? onError;

  Server(this.onData, this.onError);

  ServerSocket? server;
  bool running = false;
  List<Socket> sockets = [];

  Future<void> start() async {
    runZoned(
      () async {
        server = await ServerSocket.bind('192.168.0.159', 4000);
        running = true;
        server!.listen(onRequest);
        const message = 'Server is listening in port 4000';
        onData!(Uint8List.fromList(message.codeUnits));
      },
      onError: onError,
    );
  }

  void onRequest(Socket socket) {
    bool socketContains = sockets.contains(socket);
    if (!socketContains) {
      sockets.add(socket);
    }
    socket.listen((event) {
      onData!(event);
    });
  }

  Future<void> close() async {
    await server!.close();
    server = null;
    running = false;
  }

  void broadcast(String data) {
    onData!(Uint8List.fromList("Broadcast message : $data".codeUnits));
    for (var e in sockets) {
      e.write(data);
    }
  }
}
