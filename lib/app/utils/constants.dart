import 'dart:io';

class Constants {
  // static const API_BASE_URL_ANDROID_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com/api";
  // static const API_BASE_URL_IOS_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com/api";
  // static const SOCKET_BASE_URL_ANDROID_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com";
  // static const SOCKET_BASE_URL_IOS_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com";
  static const API_BASE_URL_ANDROID_LOCAL = "http://10.0.2.2:3000/api";
  static const API_BASE_URL_IOS_LOCAL = "http://localhost:3000/api";
  static const SOCKET_BASE_URL_ANDROID_LOCAL = "http://10.0.2.2:3000";
  static const SOCKET_BASE_URL_IOS_LOCAL = "http://localhost:3000";
}

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class MensajeStatus {
  static const enviado = 0;
  static const leido = 1;
}