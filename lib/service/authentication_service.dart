import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_football_store/main_controller.dart';
import 'package:frontend_football_store/model/request/user_authenticate_request.dart';
import 'package:frontend_football_store/model/request/user_register_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class AuthenticationService {
  void register(UserRegisterRequest request, BuildContext context) async {
     var url = Uri.parse('$baseURL/api/v1/auth/register');
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(request.toMap()),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['username'] != null) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        prefs.setString('role', jsonResponse['role']);
        prefs.setString('username', jsonResponse['username']);
        
        Navigator.pushReplacement(
          context,
           MaterialPageRoute(builder: (c) => const MainController()),
        );
        
      
      } else {
        // Обработка ошибок
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось зарегистрироваться')),
        );
      }
    } catch (e) {
      // Обработка ошибок сети
      print('Ошибка: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  static void authenticate(UserAuthenticateRequest request, BuildContext context) async {
    var url = Uri.parse('$baseURL/api/v1/auth/authenticate');
    var jsonResponse;
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(request.toMap()),
      );
      var myToken;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['username'] != null) {
        myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        prefs.setString('role', jsonResponse['role']);
        prefs.setString('username', jsonResponse['username']);
        
        Navigator.pushReplacement(
          context,
           MaterialPageRoute(builder: (context) => const MainController()),
        );
        //Navigator.of(context).pop();
      } else {
        // Обработка ошибок
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Неверный логин или пароль")),
        );
      }
    } catch (e) {
        print('Ошибка: $e');
      // Обработка ошибок сети
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}