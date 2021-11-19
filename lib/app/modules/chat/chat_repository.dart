
import 'package:get/get.dart';
import 'package:privechat/app/data/models/mensajes_response.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/modules/chat/chat_provider.dart';

class ChatRepository {

  final ChatProvider api = Get.find<ChatProvider>();

  Future<List<Mensaje>> getChat(String usuarioId) => api.getChat(usuarioId);

  Usuario get usuarioPara => api.usuarioPara;

  set usuarioPara(Usuario usuario){
    api.usuarioPara = usuario;
  }

}