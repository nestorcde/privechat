// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/modules/agenda/agenda_controller.dart';
import 'package:privechat/app/ui/widgets/container_referencia.dart';
import 'package:privechat/app/ui/widgets/custom_appbar.dart';
import 'package:privechat/app/ui/widgets/dialogo_turno.dart';
import 'package:privechat/app/utils/constants.dart';
//import 'package:privechat/app/utils/utils.dart';
//import 'package:privechat/app/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  //late final ValueNotifier<List<Event>> agendaController.selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  //DateTime agendaController.diaEnfocado.value = DateTime.now();
 // DateTime? agendaController.diaSeleccionado.value;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late final AgendaController agendaController;
  late Usuario usuario;

  @override
  void initState() {
    agendaController = Get.find<AgendaController>();
    agendaController.cargaEventos();

    agendaController.diaSeleccionado.value = agendaController.diaEnfocado.value;
    agendaController.selectedEvents.value = _getEventsForDay(agendaController.diaSeleccionado.value);
    usuario = agendaController.usuario;
    agendaController.socket.on('registra-turno', agendaController.nuevoTurno);
    super.initState();
  }

  @override
  void dispose() {
    //agendaController.selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    //print(kEventSource);
    return agendaController.kEvents.value[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = agendaController.daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(agendaController.diaSeleccionado.value, selectedDay)) {
      setState(() {
        agendaController.diaSeleccionado.value = selectedDay;
        agendaController.diaEnfocado.value = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      agendaController.selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      agendaController.diaSeleccionado.value = focusedDay;
      agendaController.diaEnfocado.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      agendaController.selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      agendaController.selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      agendaController.selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Agenda'),
      body: Column(
        children: [
          Obx(() {
            final eventos = agendaController.kEvents.value;
            //print(eventos);
            return TableCalendar<Event>(
              locale: 'es-PY',
              firstDay: agendaController.kFirstDay,
              lastDay: agendaController.kLastDay,
              focusedDay: agendaController.diaEnfocado.value,
              selectedDayPredicate: (day) => isSameDay(agendaController.diaSeleccionado.value, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                agendaController.diaEnfocado.value = focusedDay;
              },
              availableCalendarFormats: const {
                CalendarFormat.month : 'Mensual', 
                CalendarFormat.twoWeeks : '2 Semanas', 
                CalendarFormat.week : 'Semana'
              },
              weekendDays: const [DateTime.sunday],
            );
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                containerReferencia(Colors.green, 'LIBRE'),
                containerReferencia(Colors.amber, 'TU TURNO'),
                containerReferencia(Colors.grey, 'OCUPADO')
              ]
            ,),
          ),
          Obx(() {
            var eventoDeHoy = agendaController.kEvents.value[agendaController.diaSeleccionado.value];
            return Expanded(
                child: ListView.builder(
                  itemCount: horarios.length,
                  itemBuilder: (context, index) {
                    Color? color = Colors.green;
                    TurnoStatus estado = TurnoStatus.Libre;
                    String turnoUid = '';
                    String turnoNombre = '';
                    String turnoEmail = '';
                    String turnoTel = '';
                    int dia = agendaController.diaSeleccionado.value.day;
                    int mes = agendaController.diaSeleccionado.value.month;
                    int anho = agendaController.diaSeleccionado.value.year;
                    if(eventoDeHoy!=null){
                      for (var evento in eventoDeHoy) {
                        if(evento.hora==horarios[index]){
                          turnoUid = evento.id;
                          if(evento.uid.id==usuario.uid){
                            estado = TurnoStatus.Tuyo;
                            color = usuario.admin!? Colors.grey : Colors.amber;
                            turnoNombre = usuario.admin!? evento.nombre: evento.uid.nombre;
                            turnoEmail = usuario.admin!? '': evento.uid.email;
                            turnoTel = usuario.admin!? '': evento.uid.telefono;
                          }else{
                            estado = TurnoStatus.Ocupado;
                            color = Colors.grey;
                            turnoNombre = evento.uid.nombre;
                            turnoEmail = evento.uid.email;
                            turnoTel = evento.uid.telefono;
                          }
                        }
                      }
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: color,),
                      child: ListTile(
                        onTap: () {
                          TextEditingController nombreCtrl = TextEditingController();
                          switch (estado) {
                            case TurnoStatus.Ocupado:
                              agendaController.usuario.admin!?
                                dialogoTurno(
                                  'Registro de Turno', 
                                  'Turno Ocupado, Desea Eliminar el turno de $turnoNombre', 
                                  true, 
                                  'Eliminar', 
                                  ()=>agendaController.eliminarTurno(turnoUid))
                              :
                                dialogoTurno(
                                  'Registro de Turno', 
                                  'Turno Ocupado', 
                                  false, 
                                  'boton', 
                                  ()=>{});
                              break;
                            case TurnoStatus.Tuyo:
                              dialogoTurno('Registro de Turno', 
                                'Desea Eliminar su Turno', 
                                true, 
                                'Eliminar', 
                                ()=>agendaController.eliminarTurno(turnoUid));
                              break;
                            default:
                              
                              agendaController.usuario.admin!?
                                dialogoOtro(nombreCtrl, horarios[index], agendaController.diaEnfocado, agendaController.verificarTurno)
                              : 
                                dialogoTurno('Registro de Turno', 
                                  'Desea Registrar turno el $dia/${mes<10?'0$mes':mes}/$anho a las ${horarios[index]}?', 
                                  true, 
                                  'Registrar', 
                                  ()=>agendaController.verificarTurno(agendaController.diaSeleccionado.value, horarios[index], ''));

                          }
                          
                        },
                        title: agendaController.usuario.admin! && estado != TurnoStatus.Libre ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${horarios[index]} - $turnoNombre'),
                                      Text('Email: $turnoEmail  Telefono: $turnoTel'),
                                    ],
                                  )
                                :
                                  Text(horarios[index]),
                      ),
                    );
                  },
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
