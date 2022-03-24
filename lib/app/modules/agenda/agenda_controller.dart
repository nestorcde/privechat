import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/data/repository/remote/socket_repository.dart';
import 'package:privechat/app/ui/widgets/dialogo_turno.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import 'package:privechat/app/modules/agenda/agenda_repository.dart';

class AgendaController extends GetxController {

  //final AgendaRepository repository = Get.find<AgendaRepository>();
  late final AgendaRepository repository;
  
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final SocketRepository socketRepository = Get.find<SocketRepository>();
  RxList<Event> selectedEvents = <Event>[].obs;

  
  
  IO.Socket get socket => socketRepository.socket;

  Function get emit => socketRepository.emit;

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

  void nuevoTurno(data){
    if(data['uid']!=usuario.uid){
      cargaEventos();
    }
  }
  
  void cargaEventos()  {
    repository.getTurnos().then((value){
      kEventSource = value;
      value.forEach((key, value) { print(value); });
      kEvents.value = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
      )..addAll(kEventSource);      
      update();
    });
    
  }
  Future<Map<DateTime, List<Event>>> getTurnos() => repository.getTurnos();

  void registrarTurno(DateTime fecha, String hora, String nombre) async {
     final respuesta = await repository.registrarTurnos(fecha, hora, nombre);
     cargaEventos();
     socket.emit('registra-turno',{"fecha": diaEnfocado.value.toIso8601String(), "uid": usuario.uid});
     Get.snackbar('Registrar Turno', respuesta);
  }

  void eliminarTurno(String id) async {
    final respuesta = await repository.eliminarTurnos(id);
    cargaEventos();
    socket.emit('registra-turno',{"fecha": diaEnfocado.value.toIso8601String(), "uid": usuario.uid});
    Get.snackbar('Eliminar Turno', respuesta);
  }

  void verificarTurno(DateTime fecha, String hora, String nombre) async {
     final respuesta = await repository.verificarTurno(fecha, hora);
     if(respuesta.ok){
       registrarTurno(fecha, hora, '');
     }else{
       if(respuesta.conn){
         if(respuesta.propio){
            final dia = respuesta.fecha.day;
            final mes = respuesta.fecha.month;
            final anho = respuesta.fecha.year;
            dialogoTurno(respuesta.msg, 'Tiene un turno en fecha $dia/${mes<10?'0'+mes.toString():mes}/$anho', true, 'Ir a Fecha', () => setDiaSeleccionado(respuesta.fecha));
          }else{
            Get.snackbar('Registrar Turno', respuesta.msg);
            cargaEventos();
          }
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

  void registrarOtro(String horario) async{
    TextEditingController controller = TextEditingController();
    await dialogoOtro(controller, horario, diaEnfocado, verificarTurno);
    //  await Get.dialog(
    //   AlertDialog(
    //     title:  Text('Registro'),
    //     content: Text('Ingrese el nombre de la persona a la que desea agendar'),
    //     actions: [
    //       TextField(controller: controller,),
    //       TextButton(onPressed: (){
    //         if(controller.text.isNotEmpty){
    //           registrarTurno(diaEnfocado.value,horario,controller.text); 
    //           Get.back();
    //         }else{
    //           Get.snackbar('Falta Nombre', 'Ingrese nombre de la persona a la que agendaar');
    //         }
    //       }, child:  Text('OK'))
    //     ],
    //   )
    // );
  }


  

  
}
