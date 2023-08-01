
import 'dart:io';

import 'package:get/get.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/modules/profile/profile_provider.dart';

class ProfileRepository {

  final ProfileProvider api = Get.find<ProfileProvider>();

  //Usuario get usuario => api.usuario;

  Future<Usuario> updateProfile(String nombre, String telefono, Usuario usuario) => api.updateProfile(nombre, telefono, usuario);

  Future<dynamic> uploadFile(File filePath, Usuario usuario, String name) => api.uploadFile2(filePath, usuario, name);

}