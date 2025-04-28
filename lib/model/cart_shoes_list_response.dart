import 'package:frontend_football_store/model/cart_shoes_response.dart';

class CartShoesListResponse {
  final List<CartShoesResponse> items;

  CartShoesListResponse({required this.items});

  factory CartShoesListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => CartShoesResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return CartShoesListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}