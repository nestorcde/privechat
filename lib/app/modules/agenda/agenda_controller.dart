import 'package:get/get.dart';
import 'package:privechat/app/data/models/event_model.dart';
import 'package:privechat/app/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import 'package:privechat/app/modules/agenda/agenda_repository.dart';

class AgendaController extends GetxController {

  //final AgendaRepository repository = Get.find<AgendaRepository>();
  late final AgendaRepository repository;
  RxList<Event> selectedEvents = <Event>[].obs;

  late Map<DateTime, List<Event>> kEventSource;
  var  kEvents;
  final DateTime kToday = DateTime.now();
  late DateTime kFirstDay;
  late DateTime kLastDay;

  Rx<DateTime> focusedDay = DateTime.now().obs;
  
  void cargaEventos() async {
    kEventSource = await repository.getTurnos();
    kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
    )..addAll(kEventSource);
    print(kEventSource);
    selectedEvents.value = kEvents[kToday];
    update();
  }
  Future<Map<DateTime, List<Event>>> getTurnos() => repository.getTurnos();

  @override
  void onInit() {
    for (var element in horarios) {
      selectedEvents.value.add(Event(hora: element));
    }

    kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    super.onInit();
  }

  @override
  void onReady() {
    repository = Get.find<AgendaRepository>();
    // repository.getTurnos().then((value) {
    //   kEventSource = value;
    //   kEvents = LinkedHashMap<DateTime, List<Event>>(
    //   equals: isSameDay,
    //   hashCode: getHashCode,
    //   )..addAll(kEventSource);
    // });

    cargaEventos();


    
    // TODO: implement onReady
    super.onReady();
  }

  // final kEvents = LinkedHashMap<DateTime, List<Event>>(
  // equals: isSameDay,
  // hashCode: getHashCode,
  // )..addAll(kEventSource);

  // final kEventSource = { for (var item in List.generate(50, (index) => index)) DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5) : List.generate(
  //       item % 4 + 1, (index) => Event('Event $item | ${index + 1}')) }
  // ..addAll({
  //   kToday: [
  //     Event('Today\'s Event 1'),
  //     Event('Today\'s Event 2'),
  //   ],
  // });

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
