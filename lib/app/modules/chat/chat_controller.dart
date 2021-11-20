import 'package:get/get.dart';
import 'package:privechat/app/data/models/mensajes_response.dart';
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

  _init() async{
    //await getchat();
  }

  @override
  void onReady() {
    _init();
  }
  
}