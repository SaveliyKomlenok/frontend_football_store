import 'package:frontend_football_store/model/shoes_warehouse_response.dart';

class CartShoesResponse {
  final int id;
  int amount;
  final ShoesWarehouseResponse shoes;

  CartShoesResponse({
    required this.id,
    required this.amount,
    required this.shoes,
  });

  factory CartShoesResponse.fromMap(Map<String, dynamic> json) {
    return CartShoesResponse(
      id: json['id'],
      amount: json['amount'],
      shoes: ShoesWarehouseResponse.fromMap(json['shoes']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'shoes': shoes.toMap(),
    };
  }
}