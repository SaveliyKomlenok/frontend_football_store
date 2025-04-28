import 'dart:convert';
import 'package:frontend_football_store/model/cart_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class CartService {
  Future<CartResponse> listOfCarts() async {
    final url = Uri.parse('$baseURL/api/v1/carts');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return CartResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to load carts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}