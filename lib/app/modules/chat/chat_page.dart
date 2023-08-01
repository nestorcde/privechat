// ignore_for_file: unnecessary_new

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  late ChatController chatController;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    chatController = Get.find<ChatController>();
    chatController.socket.on('usuario-conectado-desconectado',chatController.actualizaEstado);
    chatController.socket.on('mensaje-personal',
        (value) => _escucharMensaje(Mensaje.fromJson(value)));
    _cargarHistorial(chatController.usuario.uid);
    chatController.socket.on('escribiendo', chatController.estaEscribiendo);
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
    return GetBuilder<ChatController>(
      builder: (_) {
        return Scaffold(
            appBar: AppBar(
                centerTitle: false,
                elevation: 1,
                backgroundColor: Colors.white,
                leadingWidth: 75,
                actions: [
                  _.usuario.admin!?
                  Switch.adaptive(value: _.usuarioPara.revisado!, onChanged: _.revisar):
                  const SizedBox()
                ],
                leading: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        onPressed:Get.back, 
                        icon: const Icon(
                          Icons.arrow_back, 
                          color: Colors.black54,
                          //size: 20,
                        )
                        ),
                      ),
                      
                    Flexible(
                      flex: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        backgroundImage: _.retImgProfile(),
                        child: _.usuarioPara.imgProfile!.isNotEmpty?
                          const SizedBox():
                          const Icon(Icons.account_circle, size: 40, color: Colors.grey,)
                        //backgroundImage:  _.usuarioPara.imgProfile!.isNotEmpty?NetworkImageWithRetry(URL_IMAGE + _.usuarioPara.imgProfile!):NetworkImageWithRetry('https://www.pinclipart.com/picdir/middle/84-841840_svg-royalty-free-library-icon-svg-profile-profile.png')
                        //backgroundImage: _.usuarioPara.imgProfile!.isEmpty?NetworkImage(URL_IMAGE + _.usuarioPara.imgProfile!):,
                      ),
                    ),
                  ],
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                    Text(
                      _.usuarioPara.nombre!,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Obx(() {

                        return Text(
                          _.escribiendo.value?
                            'Escribiendo'
                          :
                            _.usuariopara.value.online
                                ? 'Conectado'
                                : 'Desconectado',
                          style: TextStyle(
                              color: _.usuariopara.value.online || _.escribiendo.value
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        );}),
                  ],
                )),
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
            ));
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
                onChanged: chatController.textChanged,
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
                        onPressed: () {
                          _handleSubmit(_textController.text.trim());
                        })
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                            onPressed: () {
                              _handleSubmit(_textController.text.trim());
                            },
                            icon: const Icon(Icons.send)))),
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
