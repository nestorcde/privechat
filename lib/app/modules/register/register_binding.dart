import 'package:get/get.dart';
import 'package:privechat/app/modules/register/register_controller.dart';

class RegisterBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<RegisterController>(() => RegisterController());
  }
}