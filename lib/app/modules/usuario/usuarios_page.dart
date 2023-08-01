import 'package:badges/badges.dart' as bdg;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/provider/remote/socket_provider.dart';
import 'package:privechat/app/modules/chat/chat_controller.dart';
import 'package:privechat/app/modules/usuario/usuarios_controller.dart';
import 'package:privechat/app/routes/routes_app.dart';
import 'package:privechat/app/ui/widgets/custom_appbar.dart';
import 'package:privechat/app/ui/widgets/dialogo_turno.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // final usuarioService = new UsuarioService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late SocketProvider _socketProvider;
  late ChatController _chatController;

  List<Usuario> usuarios = [];
  late UsuarioController usuarioController;
  var indicador = 1;

  @override
  void initState() {
    usuarioController = Get.find<UsuarioController>();
    _chatController = Get.find<ChatController>();
    usuarioController.cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    // final usuario = authService.usuario;
    return GetBuilder<UsuarioController>(
      builder: (_) {
        _socketProvider = Get.find<SocketProvider>();

        return Scaffold(
            appBar: customAppBar('Contacto'),
            body: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: WaterDropHeader(
                  complete: Icon(
                    Icons.check,
                    color: Colors.blue[400],
                  ),
                  waterDropColor: Colors.blueAccent,
                ),
                onRefresh: () {
                  _.cargarUsuarios();
                  _refreshController.refreshCompleted();
                },
                child: //_listViewUsuarios(_)
                    Obx(() {
                  if (_socketProvider.usuarioConectado.value) {
                    //_.cargarUsuarios();
                    return _listViewUsuarios(_);
                  } else {
                    //_.cargarUsuarios();
                    return _listViewUsuarios(_);
                  }
                })));
      },
    );
  }

  ListView _listViewUsuarios(UsuarioController usuarioController) {
    //usuarioController.cargarUsuarios();
    if (!usuarioController.usuario.tutorial! && indicador == 1) {
      indicador = 0;
      Future.delayed(
          Duration.zero,
          () => dialogoTuto(
              'Bienvenid@',
              'Para poder empezar a agendar tus turnos, debes completar tu perfil con tu foto, y solicitar a la administradora que acepte tu solicitud',
              'OK',
              usuarioController.setTuto));
    }
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuariosTile(
            usuarioController.usuarios.value[i], usuarioController),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: usuarioController.usuarios.value.length);
  }

  ListTile _usuariosTile(Usuario usuario, UsuarioController usuarioController) {
    NetworkImage image = usuarioController.retImgProfile(usuario);
    return ListTile(
      tileColor: usuario.revisado! ? Colors.white : Colors.grey,
      title: Text(usuario.nombre!),
      subtitle: Text(usuario.email!),
      leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          backgroundImage: image,
          child: image == null
              ? const Icon(
                  Icons.account_circle,
                  size: 40,
                  color: Colors.grey,
                )
              : const SizedBox()),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            usuario.noLeidos! > 0
                ? bdg.Badge(
                    elevation: 0,
                    badgeColor: Colors.grey,
                    shape: bdg.BadgeShape.circle,
                    padding: const EdgeInsets.all(7),
                    badgeContent: Text(
                      usuario.noLeidos!.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: usuario.online ? Colors.green[300] : Colors.red,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ],
        ),
      ),
      //
      onTap: () async {
        _chatController.usuarioPara = usuario;
        Get.toNamed(Routes.CHAT);
      },
    );
  }
}
