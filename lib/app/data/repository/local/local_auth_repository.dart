
import 'package:get/get.dart';
import 'package:privechat/app/data/provider/local/local_auth.dart';

class LocalAuthRepository {
  final LocalAuth _localAuth = Get.find<LocalAuth>();

  Future<void> setSession(String token) async => await _localAuth.setSession(token);

  Future<String?> getSession()async => await _localAuth.getSession();

  Future<void> deleteToken() async => await _localAuth.deleteToken();
}