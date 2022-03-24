


import 'package:get/get.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';

class LandingController extends GetxController {
  AuthRepository authRepository = Get.find<AuthRepository>();
  Usuario get usuario => authRepository.usuario;
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}