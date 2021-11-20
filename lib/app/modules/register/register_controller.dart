import 'package:get/get.dart';

import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/data/repository/remote/socket_repository.dart';
import 'package:privechat/app/routes/routes_app.dart';

class RegisterController extends GetxController {

  final authRepository = Get.find<AuthRepository>();
  final SocketRepository _socketRepository = Get.find<SocketRepository>();

  RxBool autenticando = false.obs;
  RxString nombre = ''.obs, email = ''.obs, password = ''.obs;

  nomOnChange(String text){
    nombre.value = text;
  }

  pswOnChange(String text){
    password.value = text;
  }

  emailOnChange(String text){
    email.value = text;
  }

  Future register() async {
    final registroOk = await authRepository.signIn(nombre.value.trim(), email.value.trim(), password.value.trim());

    if(registroOk == true){
      Get.offNamed(Routes.USUARIO);
      _socketRepository.connect();
    }else{
      Get.snackbar('Registro Incorrecto', registroOk);
      //mostrarAlerta(context, 'Registro incorrecto', registroOk);
    }
  }
  
}