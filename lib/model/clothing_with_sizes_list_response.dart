import 'package:frontend_football_store/model/clothing_with_sizes_response.dart';

class ClothingWithSizesListResponse {
  final List<ClothingWithSizesResponse> items;

  ClothingWithSizesListResponse({required this.items});

  factory ClothingWithSizesListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ClothingWithSizesResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ClothingWithSizesListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}