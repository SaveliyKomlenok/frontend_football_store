import 'package:frontend_football_store/model/order_clothing_response.dart';

class OrderClothingListResponse {
  final List<OrderClothingResponse> items;

  OrderClothingListResponse({required this.items});

  factory OrderClothingListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => OrderClothingResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return OrderClothingListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}