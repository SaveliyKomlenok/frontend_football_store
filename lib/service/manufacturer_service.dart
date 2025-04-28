import 'dart:convert';
import 'package:frontend_football_store/model/manufacturer_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class ManufacturerService {
  Future<List<ManufacturerResponse>> getAllManufacturers() async {
    final url = Uri.parse('$baseURL/api/v1/manufacturers');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        var list = jsonResponse['items'] as List<dynamic>;
        return list.map((model) => ManufacturerResponse.fromMap(model)).toList();
      } else {
        throw Exception('Failed to load manufacturers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}