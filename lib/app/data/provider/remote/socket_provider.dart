// ignore_for_file: unnecessary_this

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:privechat/app/data/provider/remote/auth_provider.dart';
import 'package:privechat/app/ui/widgets/dialogo_turno.dart';
import 'package:privechat/app/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:get/get.dart';



class SocketProvider  {

  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  Rx<ServerStatus> serverStatus = ServerStatus.Connecting.obs;
  RxBool usuarioConectado = false.obs;
  late IO.Socket _socket;

  //ServerStatus get serverStatus => this.serverStatus.value;
  
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit; 

  Future<void> connect() async  {
    final token = await _storage.read(key: 'token');
    // Dart client
    this._socket = IO.io(Platform.isAndroid
      ? Constants.SOCKET_BASE_URL_ANDROID_LOCAL
      : Constants.SOCKET_BASE_URL_IOS_LOCAL      
      , {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token
      }
    });

    this._socket.on('connect', (_) {
      print('en Connect');
      this.serverStatus.value = ServerStatus.Online;
    });

    this._socket.on('usuario-conectado-desconectado', (_) {
      //print(_);
      //if(_['uid'] != _authProvider.usuario.uid){
        if(usuarioConectado.value){
          usuarioConectado.value = false;
        }else{
          usuarioConectado.value = true;
        }
      //}
      //print('en usuario-conectado-desconectado');
      //this.serverStatus.value = ServerStatus.Online;
    });

    this._socket.on('reiniciar', reiniciar);

    this._socket.on('disconnect', (_) {
      print('en Disconnect');
      this.serverStatus.value = ServerStatus.Offline;
    });

  }

  void disconnect(){
    this._socket.disconnect();
  }

  void reiniciar(data)async {
    print('Reiniciar ${data['uid']}');
    await dialogoTurno('Revision', 'Cambios en configuracion, se cerrara la App', false, '', (){});
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //Get.reset(clearRouteBindings: true );
  }


}