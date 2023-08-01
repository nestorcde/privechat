import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/repository/local/local_auth_repository.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/data/repository/remote/socket_repository.dart';
import 'package:privechat/app/modules/usuario/usuarios_repository.dart';
import 'package:privechat/app/utils/constants.dart';



class UsuarioController extends GetxController {
  final LocalAuthRepository _localAuthRepository = Get.find<LocalAuthRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UsuarioRepository _usuarioRepository = Get.find<UsuarioRepository>();
  final SocketRepository _socketRepository = Get.find<SocketRepository>();

  RxList usuarios = [].obs;
  //ServerStatus get serverStatus => _socketRepository.serverStatus;

  Future<void> deleteToken() async{
    await _localAuthRepository.deleteToken();
  }

  Usuario get usuario => _authRepository.usuario;

  Future<List<Usuario>> getAllUsuarios()  =>  _usuarioRepository.getUsuarios();

  setTuto() async =>_usuarioRepository.setTuto(usuario.uid!);

  Rx<ServerStatus>  estado = ServerStatus.Connecting.obs;

  cargarUsuarios() async{
      usuarios.value = await _usuarioRepository.getUsuarios();
      update();
  }
  

  void disconnect(){
    _socketRepository.disconnect();
  }
  
  NetworkImage retImgProfile(Usuario usuario){
    try {
      late NetworkImage image;
      if(usuario.imgProfile!.isNotEmpty){
        try {
          image = NetworkImage(URL_IMAGE + usuario.imgProfile!);
        } catch (e) {
          print('Error: $e');
          image = const NetworkImage('https://www.pinclipart.com/picdir/middle/84-841840_svg-royalty-free-library-icon-svg-profile-profile.png');
        }
      }else{
        image = const NetworkImage('https://www.pinclipart.com/picdir/middle/84-841840_svg-royalty-free-library-icon-svg-profile-profile.png');
      }
      return image;
    }catch (e) {
      print('Error: $e');
      return const NetworkImage('https://www.pinclipart.com/picdir/middle/84-841840_svg-royalty-free-library-icon-svg-profile-profile.png');
    }
  }

}