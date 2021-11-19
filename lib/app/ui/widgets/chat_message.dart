

//import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:privechat/app/modules/chat/chat_controller.dart';

class ChatMessage extends GetView<ChatController> {

  final String texto;
  final String uid;
  final AnimationController animationController;
  const ChatMessage({ 
    Key? key, 
    required this.texto, 
    required this.uid, 
    required this.animationController 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final authService = Provider.of<AuthService>(context, listen: false);
    return GetBuilder<ChatController>(
      builder: (_) {
        return FadeTransition(
          opacity: animationController,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animationController, 
              curve: Curves.easeOut
            ),
            child: Container(
              child: uid == _.usuario.uid// 1==1//this.uid == authService.usuario.uid
                ? _miMessage()
                : notMyMessage(),
            ),
          ),
        ); 
      },
    );
  }

  Widget _miMessage() {
    return Align(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(flex: 1, child: Text(texto, style: const TextStyle(color: Colors.white), softWrap: true,)),
            const SizedBox(width: 5,),
            const Icon(Icons.check_sharp, color: Colors.greenAccent, size: 15,)
          ],
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 50,
          right: 5
        ),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20)
        ),
      ),
      alignment: Alignment.centerRight,

    );
  }

  Widget notMyMessage() {
    return Align(
      child: Container(
        child: Text(texto, style: const TextStyle(color: Colors.white),),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 5,
          right: 50
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20)
        ),
      ),
      alignment: Alignment.centerLeft,

    );
  }
}