// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/modules/agenda/agenda_controller.dart';
import 'package:privechat/app/ui/widgets/container_referencia.dart';
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
  DateTime _focusedDay = DateTime.now();
 // DateTime? agendaController.diaSeleccionado.value;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late final AgendaController agendaController;
  late Usuario usuario;

  @override
  void initState() {
    super.initState();
    agendaController = Get.find<AgendaController>();
    agendaController.cargaEventos();

    agendaController.diaSeleccionado.value = _focusedDay;
    agendaController.selectedEvents.value = _getEventsForDay(agendaController.diaSeleccionado.value);
    usuario = agendaController.usuario;
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
        _focusedDay = focusedDay;
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
      _focusedDay = focusedDay;
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
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          Obx(() {
            final eventos = agendaController.kEvents.value;
            //print(eventos);
            return TableCalendar<Event>(
              firstDay: agendaController.kFirstDay,
              lastDay: agendaController.kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(agendaController.diaSeleccionado.value, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
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
                _focusedDay = focusedDay;
              },
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
                    int dia = agendaController.diaSeleccionado.value.day;
                    int mes = agendaController.diaSeleccionado.value.month;
                    int anho = agendaController.diaSeleccionado.value.year;
                    if(eventoDeHoy!=null){
                      for (var evento in eventoDeHoy) {
                        if(evento.hora==horarios[index]){
                          if(evento.uid.id==usuario.uid){
                            estado = TurnoStatus.Tuyo;
                            color = Colors.amber;
                            turnoUid = evento.id;
                          }else{
                            estado = TurnoStatus.Ocupado;
                            color = Colors.grey;
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
                          //border: Border.all(width: 0),
                          borderRadius: BorderRadius.circular(12.0),
                          color: color,),//Colors.grey),
                      child: ListTile(
                        onTap: () {
                          switch (estado) {
                            case TurnoStatus.Ocupado:
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
                              dialogoTurno('Registro de Turno', 
                                'Desea Registrar turno el $dia/${mes<10?'0'+mes.toString():mes}/$anho a las ${horarios[index]}?', 
                                true, 
                                'Registrar', 
                                ()=>agendaController.registrarTurno(agendaController.diaSeleccionado.value, horarios[index]));
                          }
                          
                        },
                        title: Text('${horarios[index]}'),
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
