// To parse this JSON data, do
//
//     final updateProfileResponse = updateProfileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:privechat/app/data/models/usuario_model.dart';


UpdateProfileResponse updateProfileResponseFromJson(String str) => UpdateProfileResponse.fromJson(json.decode(str));

String updateProfileResponseToJson(UpdateProfileResponse data) => json.encode(data.toJson());

class UpdateProfileResponse {
    UpdateProfileResponse({
        required this.ok,
        required this.usuario
    });

    bool ok;
    Usuario usuario;

    factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) => UpdateProfileResponse(
        ok: json["ok"],
        usuario: Usuario.fromJson(json["usuario"])
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
    };
}


