
import 'package:get/get.dart';
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/data/models/general_response.dart';
import 'package:privechat/app/modules/agenda/agenda_provider.dart';

class AgendaRepository {

final AgendaProvider api = Get.find<AgendaProvider>();

Future<Map<DateTime, List<Event>>> getTurnos() => api.getTurnos();

Future<String> registrarTurnos(DateTime fecha, String hora, String nombre)=>api.registrarTurno(fecha,hora,nombre);

Future<String> eliminarTurnos(String id) => api.eliminarTurno(id);

Future<GeneralResponse> verificarTurno(DateTime fecha, String hora) => api.verificarTurno(fecha, hora);



}