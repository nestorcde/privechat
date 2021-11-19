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
  
  Usuario _usuario = Usuario();

  Usuario get usuario => authRepository.usuario;
  
  IO.Socket get socket => socketRepository.socket;

  Function get emit => socketRepository.emit;
  
  Usuario get usuarioPara => _usuario;

  set usuarioPara(Usuario usuario){
    _usuario = usuario;
  }

  var chatList = [] ;

  Future<void> getchat() async {
    chatList = await repository.getChat(usuarioPara.uid!);
    update();
  }

  _init() async{
    await getchat();
  }

  @override
  void onReady() {
    _init();
  }
  
}