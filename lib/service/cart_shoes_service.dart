import 'dart:convert';
import 'package:frontend_football_store/model/cart_shoes_list_response.dart';
import 'package:frontend_football_store/model/cart_shoes_response.dart';
import 'package:frontend_football_store/model/request/cart_shoes_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class CartShoesService {
  static const String cartShoesUrl = "$baseURL/api/v1/cart-shoes";

  static Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<CartShoesResponse> getById(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('$cartShoesUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return CartShoesResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load cart shoes: ${response.statusCode}');
    }
  }

  static Future<CartShoesListResponse> getAll() async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse(cartShoesUrl),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return CartShoesListResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load cart shoes list: ${response.statusCode}');
    }
  }

  static Future<CartShoesResponse> save(CartShoesRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.post(
      Uri.parse(cartShoesUrl),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 201) {
      return CartShoesResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to save cart shoes: ${response.statusCode}');
    }
  }

  static Future<CartShoesResponse> update(int id, CartShoesRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.put(
      Uri.parse('$cartShoesUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 200) {
      return CartShoesResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update cart shoes: ${response.statusCode}');
    }
  }

  static Future<void> delete(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.delete(
      Uri.parse('$cartShoesUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete cart shoes: ${response.statusCode}');
    }
  }
}