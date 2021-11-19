
import 'package:get/get.dart';
import 'package:privechat/app/modules/loading/loading_controller.dart';

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoadingController());
  }
}