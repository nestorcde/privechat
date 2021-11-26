
import 'package:get/get.dart';
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/modules/agenda/agenda_provider.dart';

class AgendaRepository {

final AgendaProvider api = Get.find<AgendaProvider>();

Future<Map<DateTime, List<Event>>> getTurnos() => api.getTurnos();



}