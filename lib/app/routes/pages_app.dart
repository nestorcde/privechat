import 'package:get/get.dart';
import 'package:privechat/app/modules/agenda/agenda_page.dart';

import 'package:privechat/app/modules/chat/chat_binding.dart';
import 'package:privechat/app/modules/chat/chat_page.dart';
import 'package:privechat/app/modules/landing/landing_page.dart';
import 'package:privechat/app/modules/loading/loading_binding.dart';
import 'package:privechat/app/modules/login/login_binding.dart';
import 'package:privechat/app/modules/login/login_page.dart';
import 'package:privechat/app/modules/register/register_binding.dart';
import 'package:privechat/app/modules/register/register_page.dart';
import 'package:privechat/app/modules/usuario/usuarios_binding.dart';
import 'package:privechat/app/modules/usuario/usuarios_page.dart';
import 'package:privechat/app/routes/routes_app.dart';
import 'package:privechat/app/modules/loading/loading_page.dart';

abstract class AppPages {

  static final pages = [
    GetPage(
      name: Routes.CHAT, 
      page:()=>  const ChatPage(), 
      binding: ChatBinding()
    ),
    GetPage(
      name: Routes.LOGIN, 
      page:()=> const LoginPage(), 
      binding: LoginBinding()
    ),
    GetPage(
      name: Routes.REGISTER, 
      page:()=> const RegisterPage(), 
      binding: RegisterBinding()
    ),
    GetPage(
      name: Routes.LOADING, 
      page:()=> const LoadingPage(), 
      binding: LoadingBinding()
    ),
    GetPage(
      name: Routes.USUARIO, 
      page:()=> const UsuariosPage(), 
      binding: UsuarioBinding()
    ),
    GetPage(
      name: Routes.LANDING, 
      page:()=> LandingPage(), 
    ),
    GetPage(
      name: Routes.AGENDA, 
      page:()=> const AgendaPage(), 
    ),
    
  ];
}