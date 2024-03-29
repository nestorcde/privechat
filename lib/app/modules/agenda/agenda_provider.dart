import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/data/models/event_response.dart';
import 'package:privechat/app/data/models/general_response.dart';
import 'package:privechat/app/utils/constants.dart';


//nossa classe responsável por encapsular os métodos http
class AgendaProvider {
  
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();
  
  
  Future<Map<DateTime, List<Event>>> getTurnos() async {
    try {
      final token = await _storage.read(key: 'token');
      final resp = await http.get(Environment().apiUrl('/turnos'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      final usuariosResponse = eventResponseFromJson(resp.body);
      //print(resp.body);
      return usuariosResponse.event;
    } catch (e) {
      return {};
    }
  }
  Future<String> registrarTurno(DateTime fecha, String hora, String nombre) async {
    try {
      final token = await _storage.read(key: 'token');
      final data = {
        "dia": fecha.day,
        "mes": fecha.month,
        "anho": fecha.year,
        "hora": hora,
        "nombre": nombre
      };
      print(data);
      final resp = await http.post(Environment().apiUrl('/turnos/nuevo'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );
      print(resp.body);
      final respuesta = generalResponseFromJson(resp.body);
      return respuesta.msg;
    } catch (e) {
      return 'Error en el Registro';
    }
  }

  Future<String> eliminarTurno(String id) async {
    try {
      final token = await _storage.read(key: 'token');
      final data = {
        "id": id
      };
      final resp = await http.delete(Environment().apiUrl('/turnos/'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      final respuesta = generalResponseFromJson(resp.body);
      return respuesta.msg;
    } catch (e) {
      return 'Error al Eliminar';
    }
  }

  Future<GeneralResponse> verificarTurno(DateTime fecha, String hora) async {
    try {
      final token = await _storage.read(key: 'token');
      final data = {
        "dia": fecha.day,
        "mes": fecha.month,
        "anho": fecha.year,
        "hora": hora
      };
      final resp = await http.post(Environment().apiUrl('/turnos/verificar'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );
      print(resp.body);
      return generalResponseFromJson(resp.body);
    } catch (e) {
      return GeneralResponse(ok: false, msg: 'Error al verificar', conn: false, fecha: DateTime.now(), propio: false);
    }
  }
}