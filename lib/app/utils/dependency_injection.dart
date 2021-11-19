//import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import 'package:privechat/app/data/provider/local/local_auth.dart';
import 'package:privechat/app/data/provider/remote/auth_provider.dart';
import 'package:privechat/app/data/provider/remote/socket_provider.dart';
import 'package:privechat/app/data/repository/local/local_auth_repository.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/data/repository/remote/socket_repository.dart';
import 'package:privechat/app/modules/loading/loading_controller.dart';
import 'package:privechat/app/modules/login/login_controller.dart';
import 'package:privechat/app/modules/usuario/usuarios_provider.dart';
import 'package:privechat/app/modules/usuario/usuarios_repository.dart';
import 'package:privechat/app/modules/usuario/usuarios_controller.dart';
import 'package:privechat/app/modules/chat/chat_controller.dart';
import 'package:privechat/app/modules/chat/chat_provider.dart';
import 'package:privechat/app/modules/chat/chat_repository.dart';

class DependencyInjection {
  static void init(){
    //Varios
    Get.put<FlutterSecureStorage>(const FlutterSecureStorage());
    Get.put<Client>(Client());

    //Providers
    Get.put<LocalAuth>(LocalAuth());
    Get.put<AuthProvider>(AuthProvider());
    Get.put<SocketProvider>(SocketProvider());
    Get.put<ChatProvider>(ChatProvider());
    Get.put<UsuarioProvider>(UsuarioProvider());
    
    //Repositories
    Get.put<LocalAuthRepository>(LocalAuthRepository());
    Get.put<AuthRepository>(AuthRepository());
    Get.put<SocketRepository>(SocketRepository());
    Get.put<ChatRepository>(ChatRepository());
    Get.put<UsuarioRepository>(UsuarioRepository());

    //Controllers
    Get.put<LoadingController>(LoadingController());
    Get.put<LoginController>(LoginController());
    Get.put<UsuarioController>(UsuarioController());
    Get.put<ChatController>(ChatController());

  }
}