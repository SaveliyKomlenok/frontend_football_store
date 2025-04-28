import 'package:frontend_football_store/model/order_response.dart';

class OrderListResponse {
  final List<OrderResponse> items;

  OrderListResponse({required this.items});

  factory OrderListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => OrderResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return OrderListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}