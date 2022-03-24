import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:async/async.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:privechat/app/data/models/login_response.dart';
import 'package:privechat/app/data/models/updateProfile_response.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/data/provider/remote/auth_provider.dart';
import 'package:privechat/app/utils/constants.dart';

class ProfileProvider extends GetConnect {
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();
  final AuthProvider authProvider = Get.find<AuthProvider>();

  Future<Usuario> updateProfile(
      String nombre, String telefono, Usuario usuario) async {
    final data = {
      "uid": usuario.uid,
      "nombre": nombre,
      "telefono": telefono,
      "email": usuario.email,
      "password": "pass"
    };

    final token = await _storage.read(key: "token");
    //print('email: ${email} - pass: ${password}');
    final http.Response resp = await http.post(Environment().apiUrl('/profile'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});

    if (resp.statusCode == 200) {
      final updateProfileResponse = updateProfileResponseFromJson(resp.body);
      usuario = updateProfileResponse.usuario;

      return usuario;
    } else {
      final respBody = json.decode(resp.body);
      return usuario;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future<dynamic> uploadFile(File filePath, Usuario usuario, String name) async {
    final token = await _storage.read(key: "token");
    try {
      final formData = dio.FormData.fromMap({
        "imgProfile":  dio.MultipartFile.fromFileSync(filePath.path, filename: name)
        //"imgProfile": new MultiPartFromFile (new File("./upload.jpg"), "upload1.jpg")
      });

      dio.Response response = await Dio().post(
        URL_STRING + '/profile/imageProfile',
        data: formData,
        
        options: dio.Options(
          //contentType: 'multipart/form-data',
          headers: <String, String>{
            'x-token': token ?? '',
          }
        ),
      );
      return response;
    } on Error catch (e) {
      print(e.toString());
      return {'statusCode': 500};
    } catch (e) {
      print(e.toString());
      return {'statusCode': 500};
    }
  }

  Future uploadFile2(File filePath, Usuario usuario, String name) async {
    // string to uri
    var uri = Environment().apiUrl('/profile/imageProfile');
    final token = await _storage.read(key: "token");

    // create multipart request
    http.MultipartRequest request = http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["uid"] = usuario.uid!;

    request.headers['x-token'] = token ?? '';

    // open a byteStream
    var stream = http.ByteStream(DelegatingStream.typed(filePath.openRead()));
    // get file length
    var length = await filePath.length();

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = await http.MultipartFile.fromPath('imgProfile', filePath.path, filename: name);
    request.files.add(await http.MultipartFile.fromPath('imgProfile', filePath.path, contentType: MediaType('image', 'jpeg')));
    // send request to upload image
    http.StreamedResponse response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    if (response.statusCode == 200) {
        
        final loginResponse = updateProfileResponseFromJson(result);
        authProvider.usuario = loginResponse.usuario;
      return jsonDecode(result);
    } else {
      return  jsonDecode(result);
    }
  }
}
