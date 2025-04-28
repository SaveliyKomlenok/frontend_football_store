import 'package:frontend_football_store/model/cart_clothing_response.dart';

class CartClothingListResponse {
  final List<CartClothingResponse> items;

  CartClothingListResponse({required this.items});

  factory CartClothingListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => CartClothingResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return CartClothingListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}