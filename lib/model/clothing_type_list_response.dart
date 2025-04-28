import 'package:frontend_football_store/model/clothing_type_response.dart';

class ClothingTypeListResponse {
  final List<ClothingTypeResponse> items;

  ClothingTypeListResponse({required this.items});

  factory ClothingTypeListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ClothingTypeResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ClothingTypeListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}