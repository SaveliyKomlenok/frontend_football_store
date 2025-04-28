import 'package:frontend_football_store/model/clothing_warehouse_response.dart';

class ClothingWarehouseListResponse {
  final List<ClothingWarehouseResponse> items;

  ClothingWarehouseListResponse({required this.items});

  factory ClothingWarehouseListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ClothingWarehouseResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ClothingWarehouseListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}