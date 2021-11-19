// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:privechat/app/modules/loading/loading_controller.dart';
import 'package:privechat/app/modules/register/register_controller.dart';
import 'package:privechat/app/ui/widgets/boton_azul.dart';
import 'package:privechat/app/ui/widgets/custom_input.dart';
import 'package:privechat/app/ui/widgets/custom_logo.dart';
import 'package:privechat/app/ui/widgets/label.dart';
import 'package:privechat/app/ui/widgets/mostrar_alerta.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(builder: (_) {
      final LoadingController controller = Get.find<LoadingController>();
      return Scaffold(
          backgroundColor: Color(0xffF2F2F2),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomLogo(
                      imagePath: 'assets/tag-logo.png',
                      textLabel: 'Registro',
                    ),
                    _Form(registerCtrl: _, loadingCtrl: controller),
                    Labels(
                      texto1: '¿Ya tienes cuenta?',
                      texto2: 'Inicia sesión!',
                      ruta: 'login',
                    ),
                    Container(
                      child: Text(
                        'Terminos y Condiciones',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      margin: EdgeInsets.only(bottom: 30),
                    )
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
   _Form({Key? key, required this.loadingCtrl, required this.registerCtrl, /*this.autenticado*/})
      : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nombreController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  // TODO: implement widget
  _Form get widget => super.widget;

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
            placeholder: 'nombre',
            textController: nombreController,
            onChanged: (value)  {
              widget.registerCtrl.nomOnChange(value);
            },
          ),
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value)  {
              widget.registerCtrl.emailOnChange(value);
            },
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'password',
            textController: passwordController,
            isPassword: true,
            onChanged: (value)  {
              widget.registerCtrl.pswOnChange(value);
            },
          ),
          BotonAzul(
              autenticando: widget.registerCtrl.autenticando.value, //authService.autenticando,
              texto: 'Login',
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.registerCtrl.register();
              })
        ],
      ),
    );
  }

  void _imprimir() {
    print('Email: ${emailController.text}');
    print('Pass: ${passwordController.text}');
  }

  Future<void> _recLoged() async {
    //widget.autenticado = await widget.loadingCtrl.isLoggedIn();
  }
}
