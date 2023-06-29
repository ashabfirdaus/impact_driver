import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'global.dart';

class ActionMethod {
  static Future<String> refreshToken(Map data) async {
    const storage = FlutterSecureStorage();
    GlobalConfig.token = data['refresh_token'];
    await storage.write(key: 'token', value: data['refresh_token']);

    return data['refresh_token'];
  }

  static Future<Map> postNoAuth(String path, Map param) async {
    Uri url;
    if (GlobalConfig.typeUrl == 'prod') {
      url = Uri.https(GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path');
    } else {
      url = Uri.http(GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path');
    }

    var response = await http.post(url, body: param);
    Map data = jsonDecode(response.body);

    return {'statusCode': response.statusCode, ...data};
  }

  static Future<Map> getNoAuth(String path, Map param) async {
    Uri url;
    if (GlobalConfig.typeUrl == 'prod') {
      url = Uri.https(
          GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path', {...param});
    } else {
      url = Uri.http(
          GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path', {...param});
    }

    var response = await http.get(url);
    Map data = jsonDecode(response.body);

    return {'statusCode': response.statusCode, ...data};
  }

  static Future<Map> postAuth(String path, Map param) async {
    Uri url;
    if (GlobalConfig.typeUrl == 'prod') {
      url = Uri.https(GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path');
    } else {
      url = Uri.http(GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path');
    }

    var header = {'Authorization': 'Bearer ${GlobalConfig.token}'};
    var response = await http.post(url, body: param, headers: header);
    Map data = jsonDecode(response.body);
    try {
      if (response.statusCode == 401 && data['refresh_token'] != null) {
        String token = await refreshToken(data);
        header['Authorization'] = 'Bearer $token';
        response = await http.post(url, body: param, headers: header);
        data = jsonDecode(response.body);
      }

      if (response.statusCode == 401 && data['clear_token'] != null) {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'token');
        GlobalConfig.token = '';
      }
    } catch (e) {
      return {'statusCode': 500, 'message': 'Internal server error'};
    }

    return {'statusCode': response.statusCode, ...data};
  }

  static Future<Map> getAuth(String path, Map param) async {
    Uri url;
    if (GlobalConfig.typeUrl == 'prod') {
      url = Uri.https(
          GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path', {...param});
    } else {
      url = Uri.http(
          GlobalConfig.baseUrl, '${GlobalConfig.pathUrl}$path', {...param});
    }

    var header = {'Authorization': 'Bearer ${GlobalConfig.token}'};
    var response = await http.get(url, headers: header);
    Map data = jsonDecode(response.body);

    try {
      if (response.statusCode == 401 && data['refresh_token'] != null) {
        String token = await refreshToken(data);
        header['Authorization'] = 'Bearer $token';
        response = await http.get(url, headers: header);
        data = jsonDecode(response.body);
      }

      if (response.statusCode == 401 && data['clear_token'] != null) {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'token');
        GlobalConfig.token = '';
      }
    } catch (e) {
      return {'statusCode': 500, 'message': 'Internal server error'};
    }

    return {'statusCode': response.statusCode, ...data};
  }
}