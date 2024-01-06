import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:social_media/data/storage/secure_storage.dart';
import 'package:social_media/domain/models/response/default_response.dart';
import 'package:social_media/domain/models/response/response_login.dart';
import 'package:social_media/data/env/env.dart';

class AuthServices {

  
  Future<ResponseLogin> login(String email, String password) async {

    final resp = await http.post(Uri.parse('${Environment.urlApi}/auth-login'),
      headers: { 'Accept': 'application/json' },
      body: {
        'email' : email,
        'password': password
      }
    );
    return ResponseLogin.fromJson( jsonDecode( resp.body ));
  }


  Future<ResponseLogin> renewLogin() async {

    final token = await secureStorage.readToken();

    final resp = await http.get(Uri.parse('${Environment.urlApi}/auth/renew-login'),
      headers: { 'Accept': 'application/json', 'xxx-token' : token! }
    );
    return ResponseLogin.fromJson( jsonDecode( resp.body ));
  }

  Future<DefaultResponse> changeStatusOffline() async {
    final token = await secureStorage.readToken();
    
    final request = http.MultipartRequest(
        'PUT', Uri.parse('${Environment.urlApi}/user/status-offline'))
      ..headers['Accept'] = 'application/json'
      ..headers['xxx-token'] = token!;

    final resp = await request.send();
    var data = await http.Response.fromStream(resp);

    return DefaultResponse.fromJson(jsonDecode(data.body));
  }



}

final authServices = AuthServices();