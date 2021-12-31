
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:privechat/app/data/models/updateProfile_response.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/provider/remote/auth_provider.dart';
import 'package:privechat/app/modules/profile/profile_repository.dart';
import 'package:privechat/app/utils/constants.dart';

class ProfileController extends GetxController {
  ProfileRepository repository = Get.find<ProfileRepository>();

  final AuthProvider authProvider = Get.find<AuthProvider>();

  Rx<TextEditingController> nombreController = TextEditingController().obs;
  Rx<TextEditingController> telefonoController = TextEditingController().obs;

  late Rx<NetworkImage> profileImage ;

  //Usuario get usuario => repository.usuario;
  late Rx<Usuario> usuarioObs;
  RxBool editNombre = false.obs;
  RxBool editTelefono = false.obs;
  RxBool editEmail = false.obs;
  RxBool verBtnGuardar = false.obs;
  RxBool guardando = false.obs;

  RxString nombre = ''.obs, telefono = ''.obs, email = ''.obs;
  var isLoading = false.obs;
  var imageURL = '';
  var url = Platform.isAndroid
        ? Constants.SOCKET_BASE_URL_ANDROID_LOCAL + '/uploads/'
        : Constants.SOCKET_BASE_URL_IOS_LOCAL + '/uploads/';
       

  nomOnChange(String text) {
    nombre.value = text;
  }

  telOnChange(String text) {
    telefono.value = text;
  }

  emailOnChange(String text) {
    email.value = text;
  }

  void activarEdicion() {
    editNombre.value = true;
    editTelefono.value = true;
    //editEmail.value = true;
    verBtnGuardar.value = true;
    update();
  }

  void desactivarEdicion() {
    editNombre.value = false;
    editTelefono.value = false;
    //editEmail.value = false;
    verBtnGuardar.value = false;
    update();
  }

  void guardarDatos() {
    guardando.value = true;
    usuarioObs = authProvider.usuario.obs;
    repository.updateProfile(
        nombreController.value.text,
        telefonoController.value.text,
        usuarioObs.value).then((value){
          authProvider.usuario = value;
          nombreController.value.text = value.nombre!;
          telefonoController.value.text = value.telefono!;
          desactivarEdicion();
          guardando.value = false;

        });
  }

  void actualizarPage() {
    update();
  }

  void uploadImage(ImageSource imageSource) async {
    try {
      usuarioObs = authProvider.usuario.obs;
      final pickedFile = await ImagePicker().pickImage(source: imageSource);
      File file = convertToFile(pickedFile!);
      isLoading(true);
      if (pickedFile != null) {
        //var response = await 
        repository.uploadFile(file, usuarioObs.value, pickedFile.name).then((response) async {


        // var responseData = await response.stream.toBytes();
        // var result = String.fromCharCodes(responseData);

          if (/*response['statusCode']*/response['ok']) {
            //get image url from api response
            usuarioObs.value = updateProfileResponseFromJson(jsonEncode(response)).usuario;
            returnImage1();
            update();

            Get.snackbar('Exito', 'Imagen actualizada correctamente',
                margin: const EdgeInsets.only(top: 5,left: 10,right: 10));
            } 
          // else if (/*response['statusCode']*/response.statusCode == 401) {
          //   Get.offAllNamed(Routes.LOGIN);
          // } 
          else {
            Get.snackbar('Fallido', 'Error: ${response['msg']}'/*response['statusCode']*/,
                margin: const EdgeInsets.only(top: 5,left: 10,right: 10));
          }
        });
      } else {
        Get.snackbar('Fallido', 'Imagen no seleccionada',
            margin: EdgeInsets.only(top: 5,left: 10,right: 10));
      }
    } finally {
      isLoading(false);
    }
  }

  File convertToFile(XFile xFile) => File(xFile.path);

  returnImage() => profileImage =  NetworkImage(url + usuarioObs.value.imgProfile!).obs;
  returnImage1() => profileImage.value = new NetworkImage(url + usuarioObs.value.imgProfile!);
}
