class Constants {
  static const API_BASE_URL_ANDROID_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com/api";
  static const API_BASE_URL_IOS_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com/api";
  static const SOCKET_BASE_URL_ANDROID_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com";
  static const SOCKET_BASE_URL_IOS_LOCAL = "https://chat-app-server-nestorcde.herokuapp.com";
}

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class MensajeStatus {
  static const enviado = 0;
  static const entregado = 1;
  static const leido = 2;
}