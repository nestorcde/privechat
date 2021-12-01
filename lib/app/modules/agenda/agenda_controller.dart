import 'package:get/get.dart';
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/ui/widgets/dialogo_turno.dart';
import 'package:privechat/app/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import 'package:privechat/app/modules/agenda/agenda_repository.dart';

class AgendaController extends GetxController {

  //final AgendaRepository repository = Get.find<AgendaRepository>();
  late final AgendaRepository repository;
  
  final AuthRepository authRepository = Get.find<AuthRepository>();
  RxList<Event> selectedEvents = <Event>[].obs;

  late Map<DateTime, List<Event>> kEventSource;
  final Rx<LinkedHashMap<DateTime, List<Event>>>  kEvents = LinkedHashMap<DateTime, List<Event>>().obs;
  final DateTime kToday = DateTime.now();
  late DateTime kFirstDay;
  late DateTime kLastDay;

  Rx<DateTime> diaEnfocado = DateTime.now().obs;

  Rx<DateTime> diaSeleccionado = DateTime.now().obs;

  //var diaEnfocado;

  void setDiaSeleccionado(DateTime nvoDia){
    diaSeleccionado.value = nvoDia;
    diaEnfocado.value = nvoDia;
    update();
  }

  Usuario get usuario => authRepository.usuario;
  
  void cargaEventos()  {
    repository.getTurnos().then((value){
      kEventSource = value;
      
      kEvents.value = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
      )..addAll(kEventSource);      
      update();
    });
    
  }
  Future<Map<DateTime, List<Event>>> getTurnos() => repository.getTurnos();

  void registrarTurno(DateTime fecha, String hora) async {
     final respuesta = await repository.registrarTurnos(fecha, hora);
     cargaEventos();
     Get.snackbar('Registrar Turno', respuesta);
  }

  void eliminarTurno(String id) async {
    final respuesta = await repository.eliminarTurnos(id);
    cargaEventos();
    Get.snackbar('Eliminar Turno', respuesta);
  }

  void verificarTurno(DateTime fecha, String hora) async {
     final respuesta = await repository.verificarTurno();
     if(respuesta.ok){
       registrarTurno(fecha, hora);
     }else{
       if(respuesta.conn){
          final dia = respuesta.fecha.day;
          final mes = respuesta.fecha.month;
          final anho = respuesta.fecha.year;
          dialogoTurno(respuesta.msg, 'Tiene un turno en fecha $dia/${mes<10?'0'+mes.toString():mes}/$anho', true, 'Ir a Fecha', () => setDiaSeleccionado(respuesta.fecha));
       }else{
         Get.snackbar('Registrar Turno', respuesta.msg);
       }
     }
  }

  @override
  void onInit() {
    repository = Get.find<AgendaRepository>();

    kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
    kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    super.onInit();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }


  
}
