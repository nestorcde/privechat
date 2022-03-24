
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:privechat/app/data/provider/remote/socket_provider.dart';
import 'package:privechat/app/utils/constants.dart';

class SocketRepository {
  final SocketProvider _socketProvider = Get.find<SocketProvider>();
  
  Rx<ServerStatus> serverStatus = ServerStatus.Connecting.obs;

  //ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socketProvider.socket;

  Function get emit => _socketProvider.emit;

  Future<void> connect() async {
    _socketProvider.connect();
    serverStatus = _socketProvider.serverStatus;
  }

  void disconnect() {
    _socketProvider.disconnect();
    serverStatus = _socketProvider.serverStatus;
  }

}