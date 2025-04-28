import 'package:frontend_football_store/model/order_shoes_response.dart';

class OrderShoesListResponse {
  final List<OrderShoesResponse> items;

  OrderShoesListResponse({required this.items});

  factory OrderShoesListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => OrderShoesResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return OrderShoesListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}