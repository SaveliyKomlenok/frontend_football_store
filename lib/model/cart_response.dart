import 'package:frontend_football_store/model/cart_clothing_response.dart';
import 'package:frontend_football_store/model/cart_shoes_response.dart';

class CartResponse {
  final List<CartClothingResponse> cartClothingList;
  final List<CartShoesResponse> cartShoesList;
  double totalPrice; // Используем double для цены

  CartResponse({
    required this.cartClothingList,
    required this.cartShoesList,
    required this.totalPrice,
  });

  factory CartResponse.fromMap(Map<String, dynamic> json) {
    var clothingList = (json['cartClothingList'] as List<dynamic>?)
        ?.map((item) => CartClothingResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    var shoesList = (json['cartShoesList'] as List<dynamic>?)
        ?.map((item) => CartShoesResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return CartResponse(
      cartClothingList: clothingList,
      cartShoesList: shoesList,
      totalPrice: (json['totalPrice'] as num).toDouble(), // Приводим к double
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartClothingList': cartClothingList.map((item) => item.toMap()).toList(),
      'cartShoesList': cartShoesList.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }
}