// To parse this JSON data, do
//
//     final eventResponse = eventResponseFromJson(jsonString);

import 'dart:convert';

import 'event_model.dart';

EventResponse eventResponseFromJson(String str) => EventResponse.fromJson(json.decode(str));

String eventResponseToJson(EventResponse data) => json.encode(data.toJson());

class EventResponse {
    EventResponse({
        required this.ok,
        required this.event,
    });

    bool ok;
    Map<DateTime, List<Event>> event;

    factory EventResponse.fromJson(Map<String, dynamic> json) => EventResponse(
        ok: json["ok"],
        event: Map.from(json["event"]).map((k, v) => 
                    MapEntry<DateTime, List<Event>>(DateTime.parse(k), List<Event>.from(v.map((x) => 
                          Event.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "event": Map.from(event).map((k, v) => MapEntry<DateTime, List<Event>>(DateTime.parse(k), List<Event>.from(v.map((x) => x.toJson())))),
    };
}

