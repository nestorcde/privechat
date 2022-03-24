import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:privechat/app/modules/profile/profile_controller.dart';
import 'package:privechat/app/modules/usuario/usuarios_controller.dart';
import 'package:privechat/app/ui/widgets/boton_azul.dart';
import 'package:privechat/app/ui/widgets/custom_appbar.dart';
import 'package:privechat/app/ui/widgets/custom_input.dart';

class ProfilePage extends GetView<ProfileController> {
  final UsuarioController _usuarioController = Get.find<UsuarioController>();
  final width = Get.size.width;

  @override
  Widget build(BuildContext context) {
    //const imagen = '';

    final usuario = _usuarioController.usuario;
    // final nombreController = TextEditingController();
    // final telefonoController = TextEditingController();
    final emailController = TextEditingController();
    controller.usuarioObs = usuario.obs;
    controller.returnImage();
    controller.nombreController.value.text = usuario.nombre!;
    controller.telefonoController.value.text = usuario.telefono!;
    emailController.text = usuario.email!;
    return Scaffold(
        appBar: customAppBar('Perfil'),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15),
                width: width * 0.6,
                height: width * 0.6,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Obx(
                      () => CircleAvatar(
                          backgroundImage: controller
                              .profileImage.value //controller.returnImage(),
                          ),
                    )),
                    Positioned(
                        right: width * 0.02,
                        child: Container(
                          child: IconButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0)),
                                    ),
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            Get.back();
                                            controller.uploadImage(
                                                ImageSource.camera);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            Get.back();
                                            controller.uploadImage(
                                                ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit)),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(211, 211, 211, 0.5),
                              borderRadius: BorderRadius.circular(100)),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Informacion Personal:',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => controller.activarEdicion(),
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar Informacion Personal',
                    )
                  ],
                ),
              ),
              Obx(() => CustomInput(
                    icon: Icons.account_circle_outlined,
                    enabled: controller.editNombre.value,
                    placeholder: 'nombre',
                    textController: controller.nombreController.value,
                    onChanged: controller.nomOnChange,
                  )),
              Obx(() => CustomInput(
                    icon: Icons.phone_android,
                    enabled: controller.editTelefono.value,
                    placeholder: 'telefono',
                    textController: controller.telefonoController.value,
                    onChanged: controller.telOnChange,
                  )),
              Obx(() => CustomInput(
                    icon: Icons.email_outlined,
                    enabled: controller.editEmail.value,
                    placeholder: 'email',
                    textController: emailController,
                    onChanged: controller.emailOnChange,
                  )),
              Obx(() => Visibility(
                    visible: controller.verBtnGuardar.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BotonAzul(
                          texto: 'Guardar Datos',
                          autenticando: controller
                              .guardando.value, //authService.autenticando,
                          funcion: () {
                            FocusScope.of(context).unfocus();
                            controller.guardarDatos();
                          }),
                    ),
                  ))
            ],
          ),
        ))));
  }
}
