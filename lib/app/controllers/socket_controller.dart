// ignore_for_file: constant_identifier_names, avoid_print, prefer_final_fields

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as client;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketController extends GetxController {
  late Rx<client.Socket> _socket;

  ServerStatus _serverStatus = ServerStatus.Connecting;

  ServerStatus get serverStatus => _serverStatus;

  client.Socket get socket => _socket.value;
  Function get emit => _socket.value.emit;

  void connect(String userId) async {
    final urlBase = Uri.base.origin;

    _socket = Rx<client.Socket>(client.io(
      urlBase,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableAutoConnect() // optional
          .enableForceNew()
          .setExtraHeaders({'user_id': userId})
          .setAuth({'user_uid': userId})
          .build(),
    ));

    update();

    socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      update();
    });

    socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      update();
    });
  }

  void disconnect() {
    _socket.value.disconnect();
    update();
  }
}
