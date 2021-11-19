
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/modules/usuario/usuarios_provider.dart';
import 'package:get/get.dart';

class UsuarioRepository {

  final UsuarioProvider api = Get.find<UsuarioProvider>();

  Future<List<Usuario>> getUsuarios()  =>  api.getUsuarios();

}