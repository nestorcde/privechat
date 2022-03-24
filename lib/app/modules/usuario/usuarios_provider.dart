import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/models/usuarios_response.dart';
import 'package:privechat/app/utils/constants.dart';


//nossa classe responsável por encapsular os métodos http
class UsuarioProvider {
  
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();
  
  
  Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await _storage.read(key: 'token');
      final resp = await http.get(Environment().apiUrl('/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      final usuariosResponse = usuarioResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }

  Future<void> setTuto(String uid) async {
    try {
      final token = await _storage.read(key: 'token');
      final data = {
        "uid": uid,
      };
      final resp = await http.post(Environment().apiUrl('/usuarios/tutorial'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      if(resp.statusCode != 200){
        Get.snackbar('Error {$resp.statusCode}', 'Hablar con el administrador - ',
          margin: const EdgeInsets.only(top: 5,left: 10,right: 10));
      }
      //final usuariosResponse = usuarioResponseFromJson(resp.body);

      //return usuariosResponse.usuarios;
    } catch (e) {
      Get.snackbar('Error', 'Hablar con el administrador',
          margin: const EdgeInsets.only(top: 5,left: 10,right: 10));
    }
  }
}