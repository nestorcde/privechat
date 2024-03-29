// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/modules/loading/loading_controller.dart';
import 'package:privechat/app/modules/register/register_controller.dart';
import 'package:privechat/app/ui/widgets/boton_azul.dart';
import 'package:privechat/app/ui/widgets/custom_input.dart';
import 'package:privechat/app/ui/widgets/custom_logo.dart';
import 'package:privechat/app/ui/widgets/label.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(builder: (_) {
      final LoadingController controller = Get.find<LoadingController>();
      return Scaffold(
          backgroundColor: Color(0xffF2F2F2),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomLogo(
                      imagePath: 'assets/tag-logo.png',
                      textLabel: 'Agendame',
                    ),
                    _Form(registerCtrl: _, loadingCtrl: controller),
                    Labels(
                      texto1: '¿Ya tienes cuenta?',
                      texto2: 'Inicia sesión!',
                      ruta: 'login',
                    ),
                      SizedBox(height: 30,)
                    // GestureDetector(
                    //   child: Container(
                    //     child: Text(
                    //       'Terminos y Condiciones',
                    //       style: TextStyle(fontWeight: FontWeight.w200),
                    //     ),
                    //     margin: EdgeInsets.only(bottom: 30),
                    //   ),
                    //   onTap: () => Get.snackbar('JAJAJAJA', 'TE LA CREISTEEEE!'),
                    // )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

class _Form extends StatefulWidget {
  final LoadingController loadingCtrl;
  final RegisterController registerCtrl;
  //late bool? autenticado;
   const _Form({Key? key, required this.loadingCtrl, required this.registerCtrl, /*this.autenticado*/})
      : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    _recLoged();
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.account_circle_outlined,
            enabled: true,
            placeholder: 'nombre',
            textController: nombreController,
            onChanged: (value)  {
              widget.registerCtrl.nomOnChange(value);
            },
          ),
          CustomInput(
            icon: Icons.phone_android,
            enabled: true,
            placeholder: 'telefono',
            textController: telefonoController,
            keyboardType: TextInputType.phone,
            onChanged: (value)  {
              widget.registerCtrl.telOnChange(value);
            },
          ),
          CustomInput(
            icon: Icons.email_outlined,
            enabled: true,
            placeholder: 'email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value)  {
              widget.registerCtrl.emailOnChange(value);
            },
          ),
          CustomInput(
            icon: Icons.lock_outline,
            enabled: true,
            placeholder: 'password',
            textController: passwordController,
            isPassword: true,
            onChanged: (value)  {
              widget.registerCtrl.pswOnChange(value);
            },
          ),
          BotonAzul(
              autenticando: widget.registerCtrl.autenticando.value, //authService.autenticando,
              texto: 'Registrarse',
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.registerCtrl.register();
              })
        ],
      ),
    );
  }


  Future<void> _recLoged() async {
    //widget.autenticado = await widget.loadingCtrl.isLoggedIn();
  }
}
