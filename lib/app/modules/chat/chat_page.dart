// ignore_for_file: unnecessary_new

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/mensajes_response.dart';

import 'package:privechat/app/modules/chat/chat_controller.dart';
import 'package:privechat/app/ui/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  // late ChatService chatService;
  // late SocketService socketService;
  // late AuthService authService;

  late ChatController chatController;

  final List<ChatMessage> _messages = [];


  @override
  void initState() {
    // this.chatService = Provider.of<ChatService>(context, listen: false);
    // this.socketService = Provider.of<SocketService>(context, listen: false);
    // this.authService = Provider.of<AuthService>(context, listen: false);

    // this.socketService.socket.on('mensaje-personal', _escucharMensaje);
    chatController = Get.find<ChatController>();
    //chatController!.getchat();
    chatController.socket.on('mensaje-personal',(value) => _escucharMensaje(Mensaje.fromJson(value)));
    _cargarHistorial(chatController.usuario.uid);
    super.initState();
  }

  void _cargarHistorial(String? usuarioId) async {
    await chatController.getchat();
    List<Mensaje> chat = <Mensaje>[];
    _messages.clear();
    chat = chatController.chatList.value;
    
    final history = chat.map((m) => new ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        status: m.estado.obs,
        msgUid: m.uid,
        animationController: new AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(Mensaje payload) {
    chatController.socket.emit('mensaje-leido', {"uid": payload.uid, "deUid": payload.de});
    ChatMessage message = new ChatMessage(
        texto: payload.mensaje,
        uid: payload.de,
        msgUid: payload.uid,
        status: payload.estado.obs,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    //final usuario = chatService.usuarioPara;
    return GetBuilder<ChatController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 1,
            backgroundColor: Colors.white,
            title: Column(
              children: [
                CircleAvatar(
                  child: Text(
                    _.usuarioPara.nombre!.substring(0, 2).toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue[100],
                  maxRadius: 14,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  _.usuarioPara.nombre!,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          body: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, i) => _messages[i],
                      itemCount: _messages.length,
                      reverse: true,
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Container(
                    color: Colors.white,
                    child: _inputChat(),
                  )
                ],
              )
        );
      },
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {},
                decoration:
                    const InputDecoration.collapsed(hintText: "Enviar mensaje"),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                      child: const Text('Enviar'), 
                      onPressed: () {_handleSubmit(_textController.text.trim());}
                    )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                            onPressed: () {_handleSubmit(_textController.text.trim());}, 
                            icon: const Icon(Icons.send)
                        )
                    )
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;
    _focusNode.requestFocus();
    _textController.clear();

    final newMessage = new ChatMessage(
      texto: texto,
      uid: chatController.usuario.uid!,
      msgUid: '',
      status: 0.obs,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    //_messages.insert(0, newMessage);
    //newMessage.animationController.forward();

    // setState(() {
    // });

    chatController.emit('mensaje-personal', {
      'de': chatController.usuario.uid,
      'para': chatController.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    chatController.socket.off('mensaje-personal');
    super.dispose();
  }
}
