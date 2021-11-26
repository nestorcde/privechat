


class Event {
    Event({
         this.uid,
         this.dia,
         this.mes,
         this.anho,
        required this.hora,
         this.createdAt,
         this.updatedAt,
    });

    String? uid;
    int? dia;
    int? mes;
    int? anho;
    String hora;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        uid: json["uid"],
        dia: json["dia"],
        mes: json["mes"],
        anho: json["anho"],
        hora: json["hora"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "dia": dia,
        "mes": mes,
        "anho": anho,
        "hora": hora,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}
