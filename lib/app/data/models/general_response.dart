// To parse this JSON data, do
//
//     final generalResponse = generalResponseFromJson(jsonString);

import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) => GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) => json.encode(data.toJson());

class GeneralResponse {
    GeneralResponse({
        required this.ok,
        required this.conn,
        required this.msg,
        required this.fecha,
        required this.propio,
    });

    bool ok;
    bool conn;
    String msg;
    DateTime fecha;
    bool propio;

    factory GeneralResponse.fromJson(Map<String, dynamic> json) => GeneralResponse(
        ok: json["ok"],
        conn: json["conn"],
        msg: json["msg"],
        fecha: DateTime.parse(json["fecha"]),
        propio: json["propio"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "conn": conn,
        "msg": msg,
        "fecha": fecha.toIso8601String(),
        "propio": propio,
    };
}
