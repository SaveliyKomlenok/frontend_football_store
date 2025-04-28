import 'package:frontend_football_store/model/clothing_warehouse_response.dart';

class CartClothingResponse {
  final int id;
  final int amount;
  final ClothingWarehouseResponse clothing;

  CartClothingResponse({
    required this.id,
    required this.amount,
    required this.clothing,
  });

  factory CartClothingResponse.fromMap(Map<String, dynamic> json) {
    return CartClothingResponse(
      id: json['id'],
      amount: json['amount'],
      clothing: ClothingWarehouseResponse.fromMap(json['clothing']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'clothing': clothing.toMap(),
    };
  }
}