import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/data/models/event_response.dart';
import 'package:privechat/app/globals/environments.dart';


//nossa classe responsável por encapsular os métodos http
class AgendaProvider {
  
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();
  
  
    Future<Map<DateTime, List<Event>>> getTurnos() async {
    // try {
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
    // } catch (e) {
    //   return {};
    // }
  }
}