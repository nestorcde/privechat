import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/mensajes_response.dart';
import 'package:privechat/app/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/data/repository/remote/socket_repository.dart';
import 'package:privechat/app/modules/chat/chat_repository.dart';

class ChatController extends GetxController {

  final ChatRepository repository = Get.find<ChatRepository>();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final SocketRepository socketRepository = Get.find<SocketRepository>();
  
  Rx<Usuario> usuariopara = Usuario(online: false).obs;

  RxBool escribiendo = false.obs;

  RxString texto = ''.obs;

  Timer? _debounce;

  Usuario get usuario => authRepository.usuario;
  
  IO.Socket get socket => socketRepository.socket;

  Function get emit => socketRepository.emit;
  
  Usuario get usuarioPara => usuariopara.value;

  set usuarioPara(Usuario usuario){
    usuariopara.value = usuario;
  }

  void actualizaEstado(data) {
    if(usuariopara.value.uid == data['uid']) {
      usuariopara.value.online = data['online'];
      update();
    }
  }

  var chatList = <Mensaje>[].obs ;

  Future<void> getchat() async {
    chatList.value = await repository.getChat(usuarioPara.uid!);
    
    update();
  }

  void textChanged(String text) async{
    socket.emit('escribiendo-sale', {"deUid": usuario.uid, "paraUid": usuariopara.value.uid});
    //escribiendo.value = true;
    // texto.value = text;
    // if (_debounce?.isActive ?? false) _debounce!.cancel();
    // _debounce = Timer(const Duration(milliseconds: 1000), () {
    //     escribiendo.value = false;
    // });
  }

  void estaEscribiendo(dynamic data){
    if(usuariopara.value.uid==data['deUid']){
      escribiendo.value = true;
      update();
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 3000), () {
          escribiendo.value = false;
      });
      update();
    }
  }

  revisar(bool value) async{
    
    if(await repository.revisar(usuarioPara.uid!, value)){
      usuarioPara.revisado = value;
      socket.emit('revisa-usuario',{'uid':usuarioPara.uid});
      update();
    }
  }

  NetworkImage retImgProfile(){
    try {
      return usuarioPara.imgProfile!.isNotEmpty
              ?NetworkImage(URL_IMAGE + usuarioPara.imgProfile!)
              :const NetworkImage('https://www.pinclipart.com/picdir/middle/84-841840_svg-royalty-free-library-icon-svg-profile-profile.png');
    }on NetworkImageLoadException catch (e) {
      print('Error: $e');
      return const NetworkImage('https://www.pinclipart.com/picdir/middle/84-841840_svg-royalty-free-library-icon-svg-profile-profile.png');
    }
  }

  

  _init() async{
    
    //await getchat();
  }


  @override
  void onReady() {
    _init();
  }
  
}