// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:privechat/app/data/models/login_response.dart';
import 'package:privechat/app/data/models/usuario_model.dart';
import 'package:privechat/app/utils/constants.dart';


class AuthProvider extends GetConnect {

  //final HttpClient _httpClient = Get.find<HttpClient>();

  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  late Usuario usuario;
  

  final RxBool _autenticando = false.obs;


  bool get autenticando => _autenticando.value;

  set autenticando( bool valor ){
    _autenticando.value = valor;
  }

  

  //Getters del token 
   Future<String?> getToken() async {
    final token = await _storage.read(key: 'token');
    return token;
  }

   Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }


  Future<bool> login( String email, String password) async {

    autenticando = true;

    final data = {
      "email": email,
      "password": password
    };
    //print(jsonEncode(data));
    //print('email: ${email} - pass: ${password}');
    final http.Response  resp = await http.post(
      Environment().apiUrl('/login'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      }
    );
    autenticando = false;

    if(resp.statusCode==200){
      //print(resp.body);
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    }else{
      return false;
    }


  }

   Future signIn(String nombre, String email, String password) async {

    autenticando = true;

    final data = {
      "nombre": nombre,
      "email": email,
      "password": password
    };
    //print('email: ${email} - pass: ${password}');
    final http.Response resp = await http.post(Environment().apiUrl('/login/new'), 
      body: jsonEncode(data),
      headers:{
        'Content-Type': 'application/json',
      }
    );
    autenticando = false;

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      
        await _guardarToken(loginResponse.token);

      return true;
    }else{
      final respBody = json.decode(resp.body);
      return respBody['msg'];
    }


  }

  Future _guardarToken(String token) async{
      return await  _storage.write(key: 'token', value: token);
  }

  Future logout() async{
    return await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    autenticando = true;
    final token = await _storage.read(key: "token");
    final http.Response resp = await http.get(
      Environment().apiUrl('/login/renew'), 
      headers: {
        'Content-Type': 'application/json',
          'x-token': token ?? ''
        }
      );

    //print('Respuesta isLoggedIn: ${resp.statusCode}');

    autenticando = false;

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }else{
      logout();
      return false;
    }
  }

}