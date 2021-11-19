// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:privechat/app/modules/loading/loading_controller.dart';
import 'package:privechat/app/modules/login/login_controller.dart';
import 'package:privechat/app/ui/widgets/boton_azul.dart';
import 'package:privechat/app/ui/widgets/custom_input.dart';
import 'package:privechat/app/ui/widgets/custom_logo.dart';
import 'package:privechat/app/ui/widgets/label.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (_) {
      final loadingCtrl = Get.find<LoadingController>();
      return Scaffold(
          backgroundColor: Color(0xffF2F2F2),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomLogo(
                        imagePath: 'assets/tag-logo.png',
                        textLabel: 'Messenger',
                      ),
                      Form(loginCtrl: _/*, loadingCtrl: loadingCtrl*/),
                      Labels(
                        texto1: '¿No tienes cuenta?',
                        texto2: 'Crea una ahora!',
                        ruta: 'register',
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
            ),
          ));
    });
  }
}

class Form extends StatefulWidget {
  //final LoadingController loadingCtrl;
  //late bool? autenticado;
  final LoginController loginCtrl;
  Form(
      {Key? key,
      //required this.loadingCtrl,
      //this.autenticado,
      required this.loginCtrl})
      : super(key: key);

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  @override
  // TODO: implement widget
  Form get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    //_recLogged();
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value)  {
              widget.loginCtrl.emailOnChange(value);
            }
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'password',
            textController: passwordController,
            keyboardType: TextInputType.text,
            isPassword: true,
            onChanged: (value){
              widget.loginCtrl.pswOnChange(value);
            }
          ),
          Obx(() => BotonAzul(
              texto: 'Login',
              autenticando: widget
                  .loginCtrl.autenticando.value, //authService.autenticando,
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.loginCtrl
                    .login();
              }))
        ],
      ),
    );
  }

  bool verificado() {
    if (emailController.text == '' || passwordController.text == '')
      return false;

    return true;
  }

  void _imprimir() {}

  // Future<void> _recLogged() async {
  //   widget.autenticado = await widget.loadingCtrl.isLoggedIn();
  // }
}
