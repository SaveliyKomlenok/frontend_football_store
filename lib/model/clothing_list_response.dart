import 'package:frontend_football_store/model/clothing_response.dart';

class ClothingListResponse {
  final List<ClothingResponse> items;

  ClothingListResponse({required this.items});

  factory ClothingListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ClothingResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ClothingListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}