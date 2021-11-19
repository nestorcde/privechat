import 'package:get/get.dart';
import 'package:privechat/app/modules/chat/chat_controller.dart';

class ChatBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<ChatController>(() => ChatController());
  }
}