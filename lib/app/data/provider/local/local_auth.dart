

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LocalAuth {
  static const KEY = 'token';
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  Future<void> setSession(String token)async{
    await _storage.write(key: KEY, value: token);
  }

  Future<String?> getSession()async{
    final String? token = await _storage.read(key: KEY);
    if(token != null){
      return token;
    }
    return null;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: KEY);
  }
}