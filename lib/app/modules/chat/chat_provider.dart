
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/mensajes_response.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:http/http.dart' as http;
import 'package:privechat/app/utils/constants.dart';


class ChatProvider extends GetConnect {

  late Usuario usuarioPara;
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();



  Future<List<Mensaje>> getChat(String usuarioId) async{
    try {
      final token = await _storage.read(key: 'token');
      final resp = await http.get(Environment().apiUrl('/mensajes/$usuarioId'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      //print(resp.body);
      final mensajesResponse = mensajesResponseFromJson(resp.body);
      return mensajesResponse.mensajes;
    } catch (e) {
      return [];
    }
  }

  Future<bool> revisar(String usuarioId, bool valor) async{
    try {
      final token = await _storage.read(key: 'token');
      final data = {
        "uid": usuarioId,
        "valor": valor
      };
      final resp = await http.post(Environment().apiUrl('/usuarios/revisar'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      print(resp.body);
      if(resp.statusCode == 200){
        Get.snackbar('Exito', 'Usuario revisado',
          margin: const EdgeInsets.only(top: 5,left: 10,right: 10));
        return true;
      }else{
        Get.snackbar('Error', 'Hablar con el administrador',
          margin: const EdgeInsets.only(top: 5,left: 10,right: 10));
        return false;
      }
    } catch (e) {
        Get.snackbar('Error', 'Hablar con el administrador',
          margin: const EdgeInsets.only(top: 5,left: 10,right: 10));
        return false;
    }
  }

}