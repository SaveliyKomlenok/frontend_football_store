import 'package:frontend_football_store/model/clothing_warehouse_response.dart';

class OrderClothingResponse {
  final int id;
  final int amount;
  final ClothingWarehouseResponse clothingWarehouse;

  OrderClothingResponse({
    required this.id,
    required this.amount,
    required this.clothingWarehouse,
  });

  factory OrderClothingResponse.fromMap(Map<String, dynamic> json) {
    return OrderClothingResponse(
      id: json['id'],
      amount: json['amount'],
      clothingWarehouse: ClothingWarehouseResponse.fromMap(json['clothingWarehouse']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'clothingWarehouse': clothingWarehouse.toMap(),
    };
  }
}