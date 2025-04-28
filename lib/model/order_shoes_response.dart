import 'package:frontend_football_store/model/shoes_warehouse_response.dart';

class OrderShoesResponse {
  final int id;
  final int amount;
  final ShoesWarehouseResponse shoesWarehouse;

  OrderShoesResponse({
    required this.id,
    required this.amount,
    required this.shoesWarehouse,
  });

  factory OrderShoesResponse.fromMap(Map<String, dynamic> json) {
    return OrderShoesResponse(
      id: json['id'],
      amount: json['amount'],
      shoesWarehouse: ShoesWarehouseResponse.fromMap(json['shoesWarehouse']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'shoesWarehouse': shoesWarehouse.toMap(),
    };
  }
}