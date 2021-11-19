
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/mensajes_response.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/globals/environments.dart';
import 'package:http/http.dart' as http;


class ChatProvider extends GetConnect {

  late Usuario usuarioPara;
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();



  Future<List<Mensaje>> getChat(String usuarioId) async{
    try {
      final token = await _storage.read(key: 'token');
      final resp = await http.get(Environment().apiUrl('/mensajes/'+usuarioId),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      print(resp.body);
      final mensajesResponse = mensajesResponseFromJson(resp.body);
      return mensajesResponse.mensajes;
    } catch (e) {
      return [];
    }
  }

}