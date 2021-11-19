//import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:privechat/app/modules/chat/chat_controller.dart';
import 'package:privechat/app/utils/constants.dart';
import 'package:privechat/app/utils/mensajes_status.dart';

class ChatMessage extends GetView<ChatController> {
  final String texto;
  final String uid;
  final String msgUid;
  late Rx<int> status = 0.obs;
  final AnimationController animationController;
  ChatMessage(
      {Key? key,
      required this.texto,
      required this.uid,
      required this.msgUid,
      required this.status,
      required this.animationController})
      : super(key: key);

    setStatus(int value){
      status.value = value;
    }

  @override
  Widget build(BuildContext context) {
    //final authService = Provider.of<AuthService>(context, listen: false);
    
    
    return GetBuilder<ChatController>(
      builder: (_) {
        _.socket.on('mensaje-leido', _mensajeLeido);
        return FadeTransition(
          opacity: animationController,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: animationController, curve: Curves.easeOut),
            child: Container(
              child: uid ==
                      _.usuario.uid // 1==1//this.uid == authService.usuario.uid
                  ? _miMessage()
                  : notMyMessage(_),
            ),
          ),
        );
      },
    );
  }

  void _mensajeLeido(dynamic data) {
    print(data);
    if (uid == data['uid']) {
      status.value = MensajeStatus.leido;
    }
  }

  Widget _miMessage() {
    return Align(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
                flex: 1,
                child: Text(
                  texto,
                  style: const TextStyle(color: Colors.white),
                  softWrap: true,
                )),
            const SizedBox(
              width: 5,
            ),
            Obx(() => MessageStatusDot(
                  status: status.value,
                ))
          ],
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
      ),
      alignment: Alignment.centerRight,
    );
  }

  Widget notMyMessage(ChatController chatController) {
    chatController.socket.emit('mensaje-leido', {"uid": msgUid, "deUid": uid});
    return Align(
      child: Container(
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
      ),
      alignment: Alignment.centerLeft,
    );
  }
}
