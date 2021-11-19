import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/data/repository/remote/socket_repository.dart';
import 'package:privechat/app/routes/routes_app.dart';

class LoginController extends GetxController {
  final AuthRepository repository = Get.find<AuthRepository>();
  final SocketRepository _socketRepository = Get.find<SocketRepository>();

  RxBool loginOk = false.obs;
  RxBool autenticando = false.obs;
  RxString email = ''.obs, password = ''.obs;

  pswOnChange(String text){
    password.value = text;
  }

  emailOnChange(String text){
    email.value = text;
  }

  void login() async {
    if(verificado(email.value, password.value)){
      
      autenticando.value = true;
      //FocusScope.of(context).unfocus();
      try {
        loginOk.value = await repository.login(email.value.trim(), password.value.trim()); 
        
        if(loginOk.value){
          _socketRepository.connect();
          autenticando.value = false;
          Get.offNamed(Routes.USUARIO);
        }else{
          autenticando.value = false;
          Get.dialog(
             AlertDialog(
              title: const Text('Login Incorrecto'),
              content: const Text('Usuario o Contraseña incorrectas'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
            )
          );
        }
      } on HttpException catch(e){
          print(e.message);
          autenticando.value = false;
          Get.dialog(
             AlertDialog(
              title: const Text('Login Incorrecto'),
              content: Text('Error de Red: ${e.message}'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
            )
          );
      } on Exception catch(er){
          print(er.toString());
          autenticando.value = false;
          Get.dialog(
             AlertDialog(
              title: const Text('Login Incorrecto'),
              content: Text('Error de Red: ${er.toString()}'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
            )
          );
      }
    }else{
        autenticando.value = false;
        Get.dialog(
           AlertDialog(
            title: const Text('Login Incorrecto'),
            content: const Text('email y password obligatorios'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
          )
        );
    }

    

  }

  bool  verificado(String email, String password) {
    if(email == '' || password == '') return false;
      
      return true;
  }
}