
import 'package:get/get.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/provider/remote/auth_provider.dart';

class AuthRepository {

  final AuthProvider _api = Get.find<AuthProvider>();

  Usuario get usuario => _api.usuario;

set autenticando(bool valor) {
  _api.autenticando = valor;
}
  bool get autenticando => _api.autenticando;

  Future<bool> login(String email, String password) => _api.login(email, password);

  Future logout() => _api.logout();

  Future signIn(String nombre, String telefono, String email, String password) => _api.signIn(nombre, telefono, email, password);

  Future<bool> isLoggedIn()=> _api.isLoggedIn();

  Future<String?> getToken()=> _api.getToken();

  Future<void> deleteToken()=> _api.deleteToken();

}