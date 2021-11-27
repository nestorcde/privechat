// To parse this JSON data, do
//
//     final generalResponse = generalResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) => GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) => json.encode(data.toJson());

class GeneralResponse {
    GeneralResponse({
        required this.ok,
        required this.msg,
    });

    bool ok;
    String msg;

    factory GeneralResponse.fromJson(Map<String, dynamic> json) => GeneralResponse(
        ok: json["ok"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
    };
}
