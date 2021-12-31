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

  Rx<ServerStatus>  estado = ServerStatus.Connecting.obs;

  cargarUsuarios() async{
      usuarios.value = await _usuarioRepository.getUsuarios();
      update();
  }
  

  void disconnect(){
    _socketRepository.disconnect();
  }

}