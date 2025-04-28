import 'dart:convert';
import 'package:frontend_football_store/model/order_list_response.dart';
import 'package:frontend_football_store/model/order_response.dart';
import 'package:frontend_football_store/model/request/order_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class OrderService {
  Future<OrderListResponse> findAllOrders() async {
    final url = Uri.parse('$baseURL/api/v1/orders');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return OrderListResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<OrderResponse> createOrder(OrderRequest request) async {
    final url = Uri.parse('$baseURL/api/v1/orders');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.post(url, headers: headers, body: json.encode(request.toMap()));

      if (response.statusCode == 201) {
        return OrderResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(int id) async {
    final url = Uri.parse('$baseURL/api/v1/orders/$id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}