// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:io';

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:privechat/app/utils/constants.dart';

final url = Platform.isAndroid
        ? Constants.SOCKET_BASE_URL_ANDROID_LOCAL
        : Constants.SOCKET_BASE_URL_IOS_LOCAL;
    final imagen = url + '/uploads/blank-profile-picture.png';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        this.imgProfile,
        this.nombre,
        this.telefono,
        this.email,
        required this.online,
        this.noLeidos,
        this.revisado,
        this.tutorial,
        this.admin,
        this.uid,
    });

    String? imgProfile;
    String? nombre;
    String? telefono;
    String? email;
    bool online;
    int? noLeidos;
    bool? revisado;
    bool? tutorial;
    bool? admin;
    String? uid;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        imgProfile: json["imgProfile"] ?? imagen,
        nombre: json["nombre"],
        telefono: json["telefono"],
        email: json["email"],
        online: json["online"],
        noLeidos: json["noLeidos"],
        revisado: json["revisado"],
        tutorial: json["tutorial"],
        admin: json["admin"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "imgProfile": imgProfile,
        "nombre": nombre,
        "telefono": telefono,
        "email": email,
        "online": online,
        "noLeidos": noLeidos,
        "revisado": revisado,
        "tutorial": tutorial,
        "admin": admin,
        "uid": uid,
    };
}
