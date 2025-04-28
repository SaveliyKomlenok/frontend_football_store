import 'package:frontend_football_store/model/shoes_warehouse_response.dart';

class ShoesWarehouseListResponse {
  final List<ShoesWarehouseResponse> items;

  ShoesWarehouseListResponse({required this.items});

  factory ShoesWarehouseListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ShoesWarehouseResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ShoesWarehouseListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}