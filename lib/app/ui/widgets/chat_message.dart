//import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:privechat/app/modules/chat/chat_controller.dart';
import 'package:privechat/app/ui/widgets/mensajes_status.dart';

class ChatMessage extends StatefulWidget {



  final String texto;
  final String uid;
  final String? msgUid;
  late Rx<int> status = 0.obs;
  final AnimationController animationController;
  ChatMessage(
      {Key? key,
      required this.texto,
      required this.uid,
      this.msgUid,
      required this.status,
      required this.animationController})
      : super(key: key);
    setStatus(int value){
      status.value = value;
    }

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> with TickerProviderStateMixin{

  late ChatController chatController;
  

  void _mensajeLeido(dynamic data) {
    //print(data);
    if (widget.msgUid == data['uid'] && chatController.usuario.uid != data['paraUid']) {
      if(widget.status.value == 0){
        widget.setStatus(1);
      }
    }
  }

  @override
  void initState() {
    chatController = Get.find<ChatController>();
    chatController.socket.on('mensaje-leido', _mensajeLeido);
    super.initState();
    
  }

    

  @override
  Widget build(BuildContext context) {
    //final authService = Provider.of<AuthService>(context, listen: false);
    
    
    return GetBuilder<ChatController>(
      builder: (_) {
        
        return FadeTransition(
          opacity: widget.animationController,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: widget.animationController, curve: Curves.easeOut),
            child: Container(
              child: widget.uid ==
                      _.usuario.uid // 1==1//this.uid == authService.usuario.uid
                  ? Obx(() =>_miMessage())
                  : notMyMessage(_),
            ),
          ),
        );
      },
    );
  }

  

  Widget _miMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
                flex: 1,
                child: Text(
                  widget.texto,
                  style: const TextStyle(color: Colors.white),
                  softWrap: true,
                )),
            const SizedBox(
              width: 5,
            ),
             MessageStatusDot(status: widget.status.value,)
          ],
        ),
      ),
    );
  }

  Widget notMyMessage(ChatController chatController) {
    chatController.socket.emit('mensaje-leido-sale', {"uid": widget.msgUid, "deUid": widget.uid, "paraUid": chatController.usuario.uid});
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Text(
          widget.texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
