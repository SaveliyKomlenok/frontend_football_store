import 'package:frontend_football_store/model/cloth_size_response.dart';

class ClothSizeListResponse {
  final List<ClothSizeResponse> items;

  ClothSizeListResponse({required this.items});

  factory ClothSizeListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ClothSizeResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ClothSizeListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}