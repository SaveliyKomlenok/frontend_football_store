import 'package:frontend_football_store/model/shoes_response.dart';
import 'package:frontend_football_store/model/shoe_size_response.dart';

class ShoesWarehouseResponse {
  final ShoesResponse shoes;
  final ShoeSizeResponse size;
  final int amount;

  ShoesWarehouseResponse({
    required this.shoes,
    required this.size,
    required this.amount,
  });

  factory ShoesWarehouseResponse.fromMap(Map<String, dynamic> json) {
    return ShoesWarehouseResponse(
      shoes: ShoesResponse.fromMap(json['shoes']),
      size: ShoeSizeResponse.fromMap(json['size']),
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shoes': shoes.toMap(),
      'size': size.toMap(),
      'amount': amount,
    };
  }
}