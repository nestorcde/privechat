class Usuario {
  bool online;
  String? email;
  String? nombre;
  String? uid;

  Usuario({
    required this.online,
    this.email,
    this.nombre,
    this.uid
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      nombre: json["nombre"],
      email: json["email"],
      online: json["online"],
      uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
      "nombre": nombre,
      "email": email,
      "online": online,
      "uid": uid,
  };
}