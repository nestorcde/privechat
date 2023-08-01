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
import 'package:privechat/app/modules/agenda/agenda_controller.dart';
import 'package:privechat/app/modules/agenda/agenda_provider.dart';
import 'package:privechat/app/modules/agenda/agenda_repository.dart';
import 'package:privechat/app/modules/landing/landing_controller.dart';
import 'package:privechat/app/modules/loading/loading_controller.dart';
import 'package:privechat/app/modules/login/login_controller.dart';
import 'package:privechat/app/modules/profile/profile_controller.dart';
import 'package:privechat/app/modules/profile/profile_provider.dart';
import 'package:privechat/app/modules/profile/profile_repository.dart';
import 'package:privechat/app/modules/usuario/usuarios_provider.dart';
import 'package:privechat/app/modules/usuario/usuarios_repository.dart';
import 'package:privechat/app/modules/usuario/usuarios_controller.dart';
import 'package:privechat/app/modules/chat/chat_controller.dart';
import 'package:privechat/app/modules/chat/chat_provider.dart';
import 'package:privechat/app/modules/chat/chat_repository.dart';

class DependencyInjection {
  static Future<void> init() async {
    //Varios
    Get.put<FlutterSecureStorage>(const FlutterSecureStorage());
    Get.put<Client>(Client());

    //Providers
    Get.put<LocalAuth>(LocalAuth());
    Get.put<AuthProvider>(AuthProvider());
    Get.put<SocketProvider>(SocketProvider());
    Get.put<ChatProvider>(ChatProvider());
    Get.put<UsuarioProvider>(UsuarioProvider());
    Get.put<AgendaProvider>(AgendaProvider());
    Get.put<ProfileProvider>(ProfileProvider());

    //Repositories
    Get.put<LocalAuthRepository>(LocalAuthRepository());
    Get.put<AuthRepository>(AuthRepository());
    Get.put<SocketRepository>(SocketRepository());
    Get.put<ChatRepository>(ChatRepository());
    Get.put<UsuarioRepository>(UsuarioRepository());
    Get.put<AgendaRepository>(AgendaRepository());
    Get.put<ProfileRepository>(ProfileRepository());

    //Controllers
    Get.put<LoadingController>(LoadingController());
    Get.put<LoginController>(LoginController());
    Get.put<UsuarioController>(UsuarioController());
    Get.put<ChatController>(ChatController());
    Get.put<AgendaController>(AgendaController());
    Get.put<LandingController>(LandingController());
    Get.put<ProfileController>(ProfileController());
    Get.put<ProfileController>(ProfileController());
  }
}
