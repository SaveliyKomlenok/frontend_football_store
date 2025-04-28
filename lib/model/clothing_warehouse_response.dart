import 'package:frontend_football_store/model/clothing_response.dart';
import 'package:frontend_football_store/model/cloth_size_response.dart';

class ClothingWarehouseResponse {
  final ClothingResponse clothing;
  final ClothSizeResponse size;
  final int amount;

  ClothingWarehouseResponse({
    required this.clothing,
    required this.size,
    required this.amount,
  });

  factory ClothingWarehouseResponse.fromMap(Map<String, dynamic> json) {
    return ClothingWarehouseResponse(
      clothing: ClothingResponse.fromMap(json['clothing']),
      size: ClothSizeResponse.fromMap(json['size']),
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clothing': clothing.toMap(),
      'size': size.toMap(),
      'amount': amount,
    };
  }
}