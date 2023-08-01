class Event {
    Event({
        required this.id,
        required this.uid,
        required this.dia,
        required this.mes,
        required this.anho,
        required this.nombre,
        required this.hora,
        required this.createdAt,
        required this.updatedAt,
    });

    String id;
    Uid uid;
    int dia;
    int mes;
    int anho;
    String nombre;
    String hora;
    DateTime createdAt;
    DateTime updatedAt;

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        uid: Uid.fromJson(json["uid"]),
        dia: json["dia"],
        mes: json["mes"],
        anho: json["anho"],
        nombre: json["nombre"],
        hora: json["hora"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "uid": uid.toJson(),
        "dia": dia,
        "mes": mes,
        "anho": anho,
        "nombre": nombre,
        "hora": hora,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Uid {
    Uid({
        required this.id,
        required this.nombre,
        required this.email,
        required this.telefono
    });

    String id;
    String nombre;
    String email;
    String telefono;

    factory Uid.fromJson(Map<String, dynamic> json) => Uid(
        id: json["_id"],
        nombre: json["nombre"],
        email: json["email"],
        telefono: json["telefono"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "email": email,
        "telefono": telefono,
    };
}
