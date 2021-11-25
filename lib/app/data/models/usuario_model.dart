class Usuario {
  bool online;
  String? email;
  String? nombre;
  String? uid;
  int? noLeidos;

  Usuario({
    required this.online,
    this.email,
    this.nombre,
    this.uid,
    this.noLeidos
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      nombre: json["nombre"],
      email: json["email"],
      online: json["online"],
      uid: json["uid"],
      noLeidos: json["noLeidos"]
  );

  Map<String, dynamic> toJson() => {
      "nombre": nombre,
      "email": email,
      "online": online,
      "uid": uid,
      "noLeidos": noLeidos
  };
}