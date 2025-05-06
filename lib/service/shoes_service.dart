import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend_football_store/model/shoes_with_sizes_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class ShoesService {
  Future<Uint8List?> getShoesImage(int id) async {
    final url = Uri.parse('$baseURL/api/v1/shoes/$id/image');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return response.bodyBytes; // Return image as Uint8List
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<List<ShoesWithSizesResponse>> getAllShoes() async {
    final url = Uri.parse('$baseURL/api/v1/shoes');

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
        return list.map((model) => ShoesWithSizesResponse.fromMap(model)).toList();
      } else {
        throw Exception('Failed to load shoes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<ShoesWithSizesResponse> getShoesById(int id) async {
    final url = Uri.parse('$baseURL/api/v1/shoes/$id');

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
        return ShoesWithSizesResponse.fromMap(jsonResponse);
      } else {
        throw Exception('Failed to load shoes item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}