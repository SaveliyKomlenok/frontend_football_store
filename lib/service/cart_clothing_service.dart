import 'dart:convert';
import 'package:frontend_football_store/model/cart_clothing_list_response.dart';
import 'package:frontend_football_store/model/cart_clothing_response.dart';
import 'package:frontend_football_store/model/request/cart_clothing_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class CartClothingService {
  static const String cartClothingUrl = "$baseURL/api/v1/cart-clothing";

  static Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<CartClothingResponse> getById(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('$cartClothingUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return CartClothingResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load cart clothing: ${response.statusCode}');
    }
  }

  static Future<CartClothingListResponse> getAll() async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse(cartClothingUrl),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return CartClothingListResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load cart clothing list: ${response.statusCode}');
    }
  }

  static Future<CartClothingResponse> save(CartClothingRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.post(
      Uri.parse(cartClothingUrl),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 201) {
      return CartClothingResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to save cart clothing: ${response.statusCode}');
    }
  }

  static Future<CartClothingResponse> update(int id, CartClothingRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.put(
      Uri.parse('$cartClothingUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 200) {
      return CartClothingResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update cart clothing: ${response.statusCode}');
    }
  }

  static Future<void> delete(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.delete(
      Uri.parse('$cartClothingUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete cart clothing: ${response.statusCode}');
    }
  }
}