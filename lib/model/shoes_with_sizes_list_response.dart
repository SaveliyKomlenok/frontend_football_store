import 'package:frontend_football_store/model/shoes_with_sizes_response.dart';

class ShoesWithSizesListResponse {
  final List<ShoesWithSizesResponse> items;

  ShoesWithSizesListResponse({required this.items});

  factory ShoesWithSizesListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ShoesWithSizesResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ShoesWithSizesListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}