import 'dart:io';



class Constants {
  static const API_BASE_URL_ANDROID_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com/api";
  static const API_BASE_URL_IOS_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com/api";
  static const SOCKET_BASE_URL_ANDROID_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com";
  static const SOCKET_BASE_URL_IOS_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com";
//   static const API_BASE_URL_ANDROID_LOCAL = "http://10.0.2.2:3000/api";
//   static const API_BASE_URL_IOS_LOCAL = "http://localhost:3000/api";
//   static const SOCKET_BASE_URL_ANDROID_LOCAL = "http://10.0.2.2:3000";
//   static const SOCKET_BASE_URL_IOS_LOCAL = "http://localhost:3000";
}

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

enum TurnoStatus {
  Libre,
  Ocupado,
  Tuyo
}

class MensajeStatus {
  static const enviado = 0;
  static const leido = 1;
}

final horarios = ['08:00', '13:00', '15:00', '17:00', '19:00'];



class Environment {
   Uri apiUrl(String endpoint) =>    Uri(
                          scheme: 'https',
                          host: 'chat-app-server-nestorcde.herokuapp.com' ,
                          path: '/api'+endpoint
                        );
   String socketUrl() =>  'https://chat-app-server-nestorcde.herokuapp.com';
  //  Uri apiUrl(String endpoint) =>    Uri(
  //                         scheme: 'http',
  //                         host: Platform.isAndroid ? '10.0.2.2' : 'localhost',
  //                         port: 3000,
  //                         path: '/api'+endpoint
  //                       );
  //  String socketUrl() => Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
}